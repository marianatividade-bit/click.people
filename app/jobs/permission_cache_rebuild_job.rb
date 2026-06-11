class PermissionCacheRebuildJob < ApplicationJob
  queue_as :permissions

  # Reconstrói o cache de permissões para um colaborador e todos que o gerenciam.
  # Chamado sempre que chapter_manager_id ou stream_manager_id muda.
  # SLA: deve completar em até 5 minutos (monitorar via job latency).
  def perform(person_id)
    person = Person.find(person_id)

    PermissionCache.transaction do
      # Limpar cache existente onde person é target (as permissões sobre ela mudam)
      PermissionCache.where(target_id: person_id).delete_all

      # Recomputar permissões de cada viewer potencial sobre esse target
      build_permissions_for(person)
    end
  end

  private

  def build_permissions_for(target)
    # Próprio colaborador: vê seu próprio perfil e avaliação
    upsert(viewer: target, target: target, permissions: %i[view_profile view_evaluation view_pdi])

    # chapter_manager: vê perfil + PDI do report
    if target.chapter_manager
      upsert(viewer: target.chapter_manager, target: target,
             permissions: %i[view_profile view_pdi manage_pdi])
    end

    # stream_manager: vê perfil + nota de desempenho do report
    if target.stream_manager
      upsert(viewer: target.stream_manager, target: target,
             permissions: %i[view_profile view_score view_evaluation manage_evaluation])
    end

    # Se chapter == stream (mesma pessoa): herda todas as permissões
    if target.chapter_manager_id == target.stream_manager_id && target.chapter_manager
      upsert(viewer: target.chapter_manager, target: target,
             permissions: %i[view_profile view_evaluation view_pdi view_score manage_evaluation manage_pdi])
    end

    # Diretores: ver sub-árvore (traversal simples por profundidade limitada)
    build_director_permissions_for(target)

    # HR Admin: permissão total — gerenciada via role check direto, não no cache
    # Business Partner: permissão por org_unit — gerenciada via atribuição explícita
  end

  def build_director_permissions_for(target)
    ancestors = manager_chain(target)
    ancestors.select(&:director?).each do |director|
      upsert(viewer: director, target: target,
             permissions: %i[view_profile view_evaluation view_pdi view_score view_dashboard])
    end
  end

  # Sobe a cadeia de gestores até a raiz (max 10 níveis para evitar loop)
  def manager_chain(person, depth = 0)
    return [] if depth > 10
    managers = [person.chapter_manager, person.stream_manager].compact.uniq
    managers + managers.flat_map { |m| manager_chain(m, depth + 1) }
  end

  def upsert(viewer:, target:, permissions:)
    permissions.each do |perm|
      PermissionCache.upsert(
        { viewer_id: viewer.id, target_id: target.id,
          permission: PermissionCache.permissions[perm], cached_at: Time.current },
        unique_by: [:viewer_id, :target_id, :permission]
      )
    end
  end
end
