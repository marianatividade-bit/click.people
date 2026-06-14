# PRD — Click.People
**Produto:** Click.People — Plataforma de Gestão de Pessoas da Clicksign  
**Versão:** 1.0  
**Data:** Junho 2026  
**Autor:** Time de Pessoas & Engenharia

---

## 1. Visão Geral

Click.People é a plataforma interna de gestão de desempenho e desenvolvimento de pessoas da Clicksign. Substitui processos manuais em planilhas e ferramentas genéricas por um sistema integrado, construído sobre a realidade organizacional da Clicksign: estrutura de chapters e value streams, squads, avaliação 360°, calibração e 9-Box.

**Princípio central:** toda decisão sobre pessoas — avaliação, desenvolvimento, promoção — deve ser baseada em dados estruturados, contextualizados pela hierarquia real da organização, e acessível às pessoas certas no momento certo.

---

## 2. Problema

A Clicksign não tinha um sistema centralizado para ciclos de avaliação de desempenho. Os processos ocorriam via planilhas, e-mails e ferramentas externas desconectadas da hierarquia real da empresa (chapters + streams). Os principais problemas:

- **Fragmentação:** dados de avaliação espalhados em múltiplos arquivos sem consistência
- **Retrabalho manual:** RH configurava, enviava e consolidava avaliações manualmente a cada ciclo
- **Falta de histórico:** sem visão longitudinal do desenvolvimento de cada pessoa
- **Indicações sem controle:** processo de indicação de pares era informal e propenso a erros
- **Calibração não estruturada:** sessões de calibração e 9-Box sem suporte ferramental
- **Visibilidade limitada:** gestores sem acesso organizado ao histórico e PDI dos seus liderados

---

## 3. Objetivos do Produto

### Objetivos primários
- Digitalizar e padronizar o ciclo completo de avaliação de desempenho da Clicksign
- Reduzir o trabalho manual do time de RH na configuração e acompanhamento de ciclos
- Garantir que avaliações sigam a hierarquia real (chapter manager + stream manager)
- Criar histórico longitudinal de desempenho e desenvolvimento por pessoa

### Objetivos secundários
- Suportar sessões de calibração e posicionamento 9-Box com dados consolidados
- Centralizar PDIs e Planos de Recuperação com vínculo ao ciclo de avaliação
- Dar ao colaborador visibilidade do seu próprio histórico e feedbacks recebidos
- Gerar dados para decisões de promoção, reconhecimento e sucessão

### Métricas de sucesso
- Taxa de completude das avaliações por ciclo ≥ 90%
- Tempo de configuração de um novo ciclo < 30 minutos (vs. horas antes)
- Eliminação de planilhas paralelas no processo de avaliação
- NPS interno de satisfação com o processo de avaliação ≥ 7/10

---

## 4. Usuários e Papéis

| Papel | Quem é | O que faz no sistema |
|---|---|---|
| **hr_admin** | Time de RH / People Ops | Cria e configura ciclos, valida indicações, avança fases, acessa tudo |
| **business_partner** | BP de RH dedicado a squads | Acesso equivalente a hr_admin na área de atuação |
| **manager** | Chapter Manager ou Stream Manager | Avalia liderados, participa de calibração, cria PDIs |
| **employee** | Colaborador | Faz autoavaliação, indica pares, visualiza feedback próprio, cria PDI |

**Estrutura hierárquica da Clicksign:**
- Cada pessoa tem um **Chapter Manager** (disciplina/especialidade) e um **Stream Manager** (produto/iniciativa)
- Ambos são gestores legítimos e fazem avaliações top-down do colaborador
- Liderados diretos de cada gestor são puxados automaticamente desta hierarquia

---

## 5. Fluxo Principal: Ciclo de Avaliação de Desempenho

O ciclo é a unidade central do produto. Um ciclo percorre 5 fases sequenciais:

```
RASCUNHO → INDICAÇÕES → VALIDAÇÃO → AVALIAÇÃO → CALIBRAÇÃO → ENCERRADO
```

### Fase 0: Configuração (RH)
O RH configura o ciclo antes de abrí-lo:
- **Geral:** nome, descrição, limite de indicações de pares
- **Cronograma:** datas de início/fim de cada fase
- **Perguntas:** formulário de avaliação com tipo (escala, texto, múltipla escolha) e posição
- **Participantes:** quem entra no ciclo como avaliado; gestores e liderados são puxados automaticamente da hierarquia
- **9-Box:** configuração dos eixos (performance × potencial) e limiares de cada quadrante

**Plano de avaliadores (Participantes):**
Para cada avaliado, o sistema gera automaticamente:
- **Autoavaliação:** o próprio avaliado
- **Gestor de chapter:** chapter_manager da pessoa
- **Gestor de stream:** stream_manager da pessoa
- **Liderados:** todos que reportam ao avaliado (chapter_reports + stream_reports)

Pares aprovados na fase de indicações são adicionados ao plano na categoria "par".

### Fase 1: Indicações (Colaboradores)
- Cada colaborador indica um número configurável de pares para avaliá-lo
- Sistema valida o limite máximo de indicações por pessoa
- Indicações ficam pendentes de validação pelo RH

### Fase 2: Validação (RH)
- RH aprova ou rejeita cada indicação de par
- Indicações aprovadas passam a integrar o plano de avaliadores como tipo "par"
- RH pode adicionar ou remover avaliadores manualmente do plano

### Fase 3: Avaliação (Todos os avaliadores)
- Sistema avança automaticamente para esta fase na data configurada
- Cada avaliador vê e preenche apenas suas avaliações atribuídas
- Avaliações têm status: rascunho → em progresso → concluída
- RH acompanha taxa de completude em tempo real

### Fase 4: Calibração (RH + Gestores)
- Resultados de avaliação são consolidados em scores de performance e potencial
- RH e gestores ajustam posicionamentos no 9-Box
- Sistema calcula automaticamente o quadrante de cada pessoa com base nos limiares configurados
- Visão de grid 3×3 com todas as pessoas distribuídas

### Fase 5: Encerrado
- Resultados finais disponíveis para consulta
- Histórico de avaliação passa a compor o perfil de cada pessoa
- PDIs podem ser criados ou atualizados com base nos resultados

---

## 6. Módulos do Produto

### 6.1 Ciclos de Avaliação

**Listagem:** cards de todos os ciclos com status (rascunho, indicações abertas, validando, avaliação aberta, calibração, encerrado), data, participantes e percentual de completude.

**Tela de configuração (tabbed):**
- **Geral:** nome, descrição, max indicações de pares
- **Cronograma:** datas de cada fase com datepickers
- **Perguntas:** criação inline de perguntas com drag-and-drop para reordenar
- **Participantes:** visão agrupada por avaliado — gestores atribuídos, outros avaliadores (liderados + pares aprovados), botão de importar hierarquia em massa
- **9-Box:** eixos e limiares de quadrante configuráveis

**Avanço de fase:** botão único "Avançar ciclo" com confirmação. Ao avançar para Avaliação, gera automaticamente todas as avaliações conforme o plano de participantes.

### 6.2 Indicações de Pares

- Colaborador acessa a tela de indicações durante a fase ativa
- Indica pares com busca por nome
- Vê quantas indicações restam
- Pode cancelar indicações antes da validação

### 6.3 Validação de Indicações (RH)

- Lista de todas as indicações pendentes do ciclo
- Aprovar / rejeitar individualmente ou em massa
- Indicação aprovada → automática no plano de participantes

### 6.4 Avaliações

- Colaborador vê lista de avaliações pendentes e concluídas
- Formulário de avaliação com as perguntas do ciclo
- Salva como rascunho ou envia como concluída
- Visualização de avaliação concluída somente para o avaliado (resultado agregado/anônimo para pares)

### 6.5 9-Box e Calibração

- Grid 3×3 visual com todas as pessoas do ciclo posicionadas
- Eixo X: Performance (calculada a partir das respostas de avaliação)
- Eixo Y: Potencial (idem)
- Limiares configuráveis para cada eixo (ex: baixo < 3.0, médio 3.0–4.0, alto > 4.0)
- Rótulos de quadrante configuráveis por ciclo
- Possibilidade de ajuste manual de posição em calibração

### 6.6 Perfil de Colaboradores

- Foto/avatar com iniciais
- Cargo, status (ativo/inativo), e-mail
- Chapter Manager e Stream Manager
- Time de chapter (liderados diretos)
- Histórico das últimas avaliações com score de performance e potencial por ciclo
- Links para PDI e Planos de Recuperação ativos

### 6.7 PDI (Plano de Desenvolvimento Individual)

- Criado por gestor ou colaborador (vinculado a um resultado de ciclo ou independente)
- Campos: objetivo de desenvolvimento, ações, prazo, responsável
- Status: em andamento / concluído / cancelado
- Histórico de PDIs por colaborador

### 6.8 Plano de Recuperação

- Criado pelo gestor / RH para colaboradores com baixa performance
- Campos: diagnóstico, metas, suporte necessário, prazo de reavaliação
- Visibilidade restrita (gestor + RH + colaborador)

### 6.9 Feedbacks

- Feedbacks 1:1 entre quaisquer colaboradores
- Campos: para quem, tipo (reconhecimento / desenvolvimento), mensagem
- Feedbacks recebidos visíveis no perfil

### 6.10 Administração — Organização (RH Admin)

Área restrita a hr_admin e business_partner:
- **Colaboradores:** CRUD completo, definição de chapter_manager e stream_manager, ativação/desativação, pré-cadastro sem Google UID (para novos colaboradores antes da primeira autenticação)
- **Cargos:** tabela de cargos disponíveis na empresa

### 6.11 Notificações

- Notificações in-app para: nova avaliação atribuída, indicação aprovada/rejeitada, ciclo avançado de fase, novo feedback recebido
- Badge de contagem na sidebar
- Marcar como lida individualmente ou tudo de uma vez

---

## 7. Modelo de Dados

### Entidades principais

```
Person
  name, email, role (hr_admin | business_partner | manager | employee)
  chapter_manager_id → Person
  stream_manager_id → Person
  google_uid, active, position

Cycle
  name, description, status
  max_peer_nominations
  nominations_start/end, validations_start/end
  evaluation_start/end, calibration_start/end
  nine_box_config (JSON: axis labels + thresholds)
  created_by → Person

Question
  cycle → Cycle
  text, question_type (scale | text | multiple_choice)
  options (JSON), position, required

CycleParticipant
  cycle → Cycle, person → Person

CycleEvaluationPlan
  cycle → Cycle
  evaluator → Person, evaluated → Person
  evaluation_type (self_eval | chapter_manager | stream_manager | peer | direct_report)
  origin (from_hierarchy | manual)

Nomination
  cycle → Cycle
  nominator → Person, nominated → Person
  status (pending | approved | rejected)

Evaluation
  cycle → Cycle
  evaluator → Person, evaluated → Person
  evaluation_type
  status (draft | in_progress | completed | expired)
  completed_at

Answer
  evaluation → Evaluation, question → Question
  value (string)

CycleResult
  cycle → Cycle, person → Person
  performance_score (float), potential_score (float)
  quadrant (string)

PDI
  person → Person, cycle → Cycle (optional)
  title, description, due_date, status

RecoveryPlan
  person → Person, created_by → Person
  diagnosis, goals, support_needed, review_date, status

Feedback
  giver → Person, receiver → Person
  feedback_type (recognition | development)
  message

Notification
  person → Person
  title, body, notifiable (polymorphic), read_at
```

---

## 8. Arquitetura Técnica

| Camada | Tecnologia |
|---|---|
| Framework | Ruby on Rails 8.1.3 |
| Banco de dados | SQLite (desenvolvimento) / PostgreSQL (produção) |
| Frontend | Hotwire (Turbo + Stimulus), ERB |
| Autenticação | Devise + OmniAuth Google OAuth2 (SSO-only) |
| Design system | CLS-Basics (DM Sans, #F25924, 60/30/10) |
| Assets | Rails Asset Pipeline (Propshaft) |
| Storage | Active Storage |

**Decisões de arquitetura:**
- **SSO-only:** nenhum login com senha. Colaboradores se autenticam via Google Workspace da Clicksign. Pré-cadastro por e-mail sem UID para novos colaboradores.
- **Hierarquia dupla:** cada pessoa tem dois gestores independentes (chapter + stream), ambos relevantes para avaliação.
- **Plano de avaliadores:** a geração de pares avaliador→avaliado é feita via `CycleEvaluationPlan`, separando a configuração (quem avalia quem) da execução (a avaliação em si).
- **Enum extensível:** tipos de avaliação são integers no banco, permitindo adicionar novos tipos sem migration.

---

## 9. Requisitos Não-Funcionais

### Segurança
- Autenticação obrigatória em todas as rotas
- Avaliações anônimas: avaliado não vê quem é o avaliador (exceto gestores e autoavaliação)
- Acesso à área admin restrito por papel (hr_admin / business_partner)
- Credenciais OAuth nunca commitadas; carregadas via variáveis de ambiente

### Privacidade
- Resultados de calibração e 9-Box visíveis apenas para RH e gestores
- PDIs e Planos de Recuperação com acesso controlado por papel

### Performance
- Carregamento de listas com N+1 eliminado via includes do ActiveRecord
- Ciclos com centenas de participantes devem carregar em < 2s

### Usabilidade
- Interface responsiva (desktop first, mas funcional em tablet)
- Navegação via sidebar persistente com agrupamento por domínio
- Feedback visual imediato para ações (Turbo Streams / flash messages)

---

## 10. Roadmap por Fase

### Fase 1 — MVP (Ciclo básico) ✅ Em construção
- [x] Autenticação Google SSO
- [x] Gestão de colaboradores (admin)
- [x] Criação e configuração de ciclos
- [x] Perguntas configuráveis por ciclo
- [x] Participantes: plano de avaliadores com hierarquia automática
- [x] Indicações de pares + validação pelo RH
- [x] Avaliações (preenchimento + acompanhamento)
- [x] 9-Box visual configurável
- [x] PDI e Plano de Recuperação (básico)
- [x] Feedbacks
- [x] Notificações in-app
- [x] Perfil de colaborador com histórico

### Fase 2 — Calibração e Resultados
- [ ] Sessão de calibração: edição de posicionamento 9-Box por RH/gestores
- [ ] Cálculo automático de performance_score e potential_score a partir das respostas
- [ ] Tela de resultado individual com radar/scores
- [ ] Exportação de resultados (CSV, relatório PDF por colaborador)
- [ ] Dashboard de RH com visão agregada do ciclo

### Fase 3 — Desenvolvimento e Engajamento
- [ ] Metas individuais vinculadas ao PDI
- [ ] Acompanhamento de PDI por gestor com check-ins
- [ ] Feedback contínuo (lightweight, fora de ciclo)
- [ ] Histórico de promoções e movimentações
- [ ] Comparativo de performance ao longo de ciclos

### Fase 4 — Inteligência e Automação
- [ ] Sugestão automática de pares baseada em colaborações reais
- [ ] Alertas de risco (liderado sem avaliação no prazo, gestor com pendências)
- [ ] Import em massa de colaboradores via CSV
- [ ] API interna para integração com HRIS/payroll
- [ ] Dashboard executivo de saúde organizacional

---

## 11. Fora de Escopo (v1)

- Avaliação de metas por OKR (apenas desempenho comportamental/competências)
- Gestão de salários e benefícios
- Recrutamento e onboarding formal
- Integração com sistemas de ponto/presença
- App mobile nativo
- Multi-empresa (produto Clicksign exclusivo)

---

## 12. Glossário

| Termo | Definição |
|---|---|
| **Chapter** | Grupo disciplinar (ex: Engenharia, Design, Produto) com um Chapter Manager |
| **Stream** | Iniciativa ou produto (ex: Squad Assinatura, Squad Plataforma) com um Stream Manager |
| **Ciclo** | Período de avaliação de desempenho com início e fim definidos |
| **Plano de participantes** | Conjunto de pares avaliador→avaliado definidos para um ciclo |
| **9-Box** | Matriz 3×3 que posiciona colaboradores em Performance × Potencial |
| **PDI** | Plano de Desenvolvimento Individual: ações de crescimento com prazo |
| **Plano de recuperação** | Plano estruturado para colaborador com performance abaixo do esperado |
| **Business Partner** | Profissional de RH dedicado a áreas específicas, com acesso administrativo |
