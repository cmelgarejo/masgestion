module ActiveAdminAddons
  class ColorBuilder < CustomBuilder

    def render
      'PUTE'
    end

  end
  module ColorValues
    module ::ActiveAdmin
      module Views
        class TableFor
          def color_column(*args, &block)
            column(*args) { |model| ColorBuilder.render(self, model, *args, &block) }
          end
        end
        class AttributesTable
          def color_row(*args, &block)
            row(*args) { |model| ColorBuilder.render(self, model, *args, &block) }
          end
        end
      end
    end
  end
end
