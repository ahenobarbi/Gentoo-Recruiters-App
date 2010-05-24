require 'permissions/set'
module Permissions
  module AnyoneCanViewRecruiterCanChange
    multi_permission :create, :update, :destroy do
      User.user_is_recruiter?(acting_user)
    end

    def view_permitted?(field)
      true
    end
  end
end
