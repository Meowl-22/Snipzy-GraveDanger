if (!triggered)
{
    triggered = true;
    
    // Using the real name: obj_dialogue
    if (instance_exists(obj_shakytext))
    {
        obj_shakytext.fade_duration = text_duration;
        obj_shakytext.trigger_text(text_to_show);
    }
    
    instance_destroy();
}