require "./lib/rbrt/state"

module Rbrt::DomainState
  def self.extended(domain_object)
    domain_object.set_state(State.new)
  end

  def state
    @state
  end

  def set_state(state)
    @state = state
  end
end