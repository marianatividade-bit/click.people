class CycleSnapshot < ApplicationRecord
  belongs_to :cycle
  belongs_to :person
  belongs_to :chapter_manager, class_name: "Person", optional: true
  belongs_to :stream_manager,  class_name: "Person", optional: true

  # Imutável — proibir update após criação
  before_update { raise ActiveRecord::ReadOnlyRecord }
end
