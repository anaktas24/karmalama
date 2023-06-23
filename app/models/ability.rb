# class Ability
#   include CanCan::Ability

#   def initialize(user)
#     user ||= User.new # guest user

#     if user.admin?
#       can :manage, :all
#     else
#       can :read, Listing
#       # Add more abilities as per your requirements
#     end
#   end
# end
