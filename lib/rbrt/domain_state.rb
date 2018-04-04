require "rbrt/state"

module Rbrt::DomainState
  def self.extended(domain_object)
  end

  def state
    @state
  end

  def set_state(state)
    @state = state
    self
  end
end
