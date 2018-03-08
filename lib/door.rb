require "aasm"

def make_lock(name)
  aasm "#{name}_lock".to_sym, namespace: name.to_sym do
    state :unlocked, initial: true
    state :locked
    
    event "lock_#{name}".to_sym do
      transitions to: :locked
    end
    
    event "unlock_#{name}".to_sym do
      transitions to: :unlocked
    end
  end
end

class Door
  include AASM
  
  aasm do
    state :closed, initial: true
    state :open
    
    event :open do
      transitions to: :open, if: [:deadbolt_unlocked?, :knob_unlocked?]
    end
    
    event :close do
      transitions to: :closed, if: :deadbolt_unlocked?
    end
  end
  
  make_lock("knob")
  make_lock("deadbolt")
  
end

