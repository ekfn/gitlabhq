module QA
  module Page
    module Shared
      module ClonePanel
        def choose_repository_clone_http
          choose_repository_clone('HTTP', 'http')
        end

        def choose_repository_clone_ssh
          # It's not always beginning with ssh:// so detecting with @
          # would be more reliable because ssh would always contain it.
          # We can't use .git because HTTP also contain that part.
          choose_repository_clone('SSH', '@')
        end

        def repository_location
          Git::Location.new(find('#project_clone').value)
        end

        def wait_for_push
          sleep 5
          refresh
        end

        private

        def choose_repository_clone(kind, detect_text)
          wait(reload: false) do
            click_element :clone_dropdown

            page.within('.clone-options-dropdown') do
              click_link(kind)
            end

            # Ensure git clone textbox was updated
            repository_location.git_uri.include?(detect_text)
          end
        end
      end
    end
  end
end