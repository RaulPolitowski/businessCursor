class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, Status
    if user.id == 1
      can :manage, Status
    else
      can :show, Status
      can :get_status_cliente, Status
    end

    can :manage, Dashboard
    if [1,2,4,27,23,85,90].include? user.id
      can :resultados, Dashboard
      can :resultados_gruber, Dashboard
    else
      cannot :resultados, Dashboard
      cannot :resultados_gruber, Dashboard
    end
  end
end

