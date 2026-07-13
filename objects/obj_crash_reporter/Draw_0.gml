if (consoleFont != -1) draw_set_font(consoleFont);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var emHeight = string_height("M");
var drawX = round(shellOriginX);
var drawY = round(shellOriginY);

// Window Shadow
draw_set_alpha(consoleAlpha * 0.4);
draw_set_color(c_black);
draw_roundrect_ext(drawX - 2, drawY + 2, drawX + width + 2, drawY + height + 4, 10, 10, false);

// Main Console Box Pane
draw_set_alpha(consoleAlpha);
draw_set_color(consoleColor);
draw_roundrect_ext(drawX, drawY, drawX + width, drawY + height, 8, 8, false);

// Top Accent Banner Trim Line
draw_set_alpha(min(1.0, consoleAlpha + 0.2));
draw_set_color(promptColor);
draw_line_width(drawX + 4, drawY + 1, drawX + width - 4, drawY + 1, 2);

// Render Crash Details text 
draw_set_alpha(1.0);
draw_set_color(promptColor);
draw_text(drawX + consolePaddingH, drawY + consolePaddingV, "!! SYSTEM CRASH CAUGHT !!");

draw_set_color(fontColor);
var textX = drawX + consolePaddingH;
var textY = drawY + consolePaddingV + emHeight + 6;
var maxTextWidth = width - (consolePaddingH * 2);
draw_text_ext(textX, textY, global.crash_log, emHeight + 2, maxTextWidth);

draw_set_color(fontColorSecondary);
draw_text(drawX + consolePaddingH, drawY + height - emHeight - consolePaddingV, "Press SPACE to return to Hub Room.");

// Reset Draw Engine Defaults
draw_set_color(c_white);
draw_set_font(-1);