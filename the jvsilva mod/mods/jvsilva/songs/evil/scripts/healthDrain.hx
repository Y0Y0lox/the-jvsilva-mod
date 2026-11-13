// Codename Engine 1.0.1 - Health Drain
// Opponent tap notes drain health, but cannot drain below minHealth.

var drainAmount:Float = 0.02;
var minHealth:Float = 0.10;
var drainSustains:Bool = false;

function onDadHit(event) {
    // By default, don't drain repeatedly on sustain-note pieces.
    if (!drainSustains && event.note != null && event.note.isSustainNote)
        return;

    // Stop the drain before it kills the player.
    if (health <= minHealth) {
        event.healthGain = 0;
        return;
    }

    // In Codename Engine, opponent-side health gain is subtracted
    // from the player's health automatically.
    event.healthGain = Math.min(drainAmount, health - minHealth);
}
