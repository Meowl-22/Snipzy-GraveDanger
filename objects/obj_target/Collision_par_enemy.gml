// Check if the pizzaboy instance colliding with us is currently thrown/hit
// Adjust "states.hit" or "states.stun" based on your exact engine setup
if (other.state == states.hit) {
    
    // 1. Loop through and destroy the assigned targets from creation code
    var _size = array_length(destroy_targets);
    
    for (var i = 0; i < _size; i++) {
        var _target = destroy_targets[i];
        
        if (instance_exists(_target)) {
            with (_target) {
                instance_destroy();
            }
        }
    }
    
    // 2. Destroy this object itself
    instance_destroy();
}