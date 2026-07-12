function menu_get_file_percentage(_filename)
{
	global.draw_bignumber_counter = function(_x, _y, _value = 0) 
{
    draw_set_font(global.bignumber_font);
    draw_text(_x, _y, string(_value));
}

    var _path = $"saves/saveData{_filename}.ini";
    if (!file_exists(_path)) 
    {
        _path = $"saveData{_filename}.ini";
    }
    
    if (!file_exists(_path)) return 0;
    
    var _level_list = ["Entrance", "Medieval", "Ruin", "Dungeon"]; 
    
    // --- ADJUST YOUR GAME percentages DIRECTLY HERE ---
    var rank_rewards   = [0, 0, 0, 1, 2, 3]; // Index: 0=D, 1=C, 2=B, 3=A, 4=S, 5=P
    var toppin_rewards = [1, 0, 0, 0, 0];    // Points per Toppin: [Shroom, Cheese, Tomato, Sausage, Pineapple]
    
    var _calculated_total = 0;
    ini_open(_path);
    
    for (var i = 0; i < array_length(_level_list); i++)
    {
        var _lvl = _level_list[i];
        
        if (ini_section_exists(_lvl))
        {
            // --- Rank Handling ---
            if (ini_key_exists(_lvl, "rank"))
            {
                var _saved_rank_str = ini_read_string(_lvl, "rank", "0");
                var _saved_rank = floor(real(_saved_rank_str)); 
                
                _calculated_total += rank_rewards[clamp(_saved_rank, 0, array_length(rank_rewards) - 1)];
            }
            
            // --- Toppins Handling ---
            var _toppins = ["shroom", "cheese", "tomato", "sausage", "pineapple"];
            for (var j = 0; j < array_length(_toppins); j++)
            {
                if (ini_key_exists(_lvl, _toppins[j]))
                {
                    var _has_toppin_str = ini_read_string(_lvl, _toppins[j], "0");
                    var _has_toppin = real(_has_toppin_str);
                    
                    if (_has_toppin > 0)
                    {
                        _calculated_total += toppin_rewards[clamp(j, 0, array_length(toppin_rewards) - 1)];
                    }
                }
            }
        }
    }
    
    ini_close();
    
    return _calculated_total; // Completely removed the 102 clamp so you can see any total!
}