class WikiPolicy < ApplicationPolicy

    def update?
        record.user == user
    end

end