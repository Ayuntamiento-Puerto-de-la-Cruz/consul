class Abilities::SUA::Manager
  include CanCan::Ability

  def initialize(user)
    merge Abilities::Common.new(user)

    can :read, ::SUA::Target
    can [:read, :update, :destroy], Widget::Card, cardable_type: "SUA::Phase"
    can(:create, Widget::Card) { |card| card.cardable_type == "SUA::Phase" }
  end
end
