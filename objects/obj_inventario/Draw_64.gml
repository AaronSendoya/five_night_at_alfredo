/// @description Dibujar Interfaz Grid

if (!inventory_visible) exit;

// 1. FONDO OSCURO (Overlay para pausar la atención)
draw_set_alpha(0.6);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

// 2. CÁLCULOS DE POSICIÓN (Centrado en pantalla)
var _grid_w = (slot_size * col_slots) + (slot_sep * (col_slots - 1));
var _rows = ceil(total_slots / col_slots);
var _grid_h = (slot_size * _rows) + (slot_sep * (_rows - 1));

var _start_x = (gui_width - _grid_w) / 2;
var _start_y = (gui_height - _grid_h) / 2;

// Título
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(gui_width/2, _start_y - 30, "INVENTARIO");

// 3. DIBUJAR LOS SLOTS
for (var i = 0; i < total_slots; i++) {
    // Coordenadas del slot actual
    var _col = i % col_slots;
    var _row = i div col_slots;
    
    var _xx = _start_x + (_col * (slot_size + slot_sep));
    var _yy = _start_y + (_row * (slot_size + slot_sep));
    
    // A. Dibujar la caja del slot (Fondo gris oscuro, borde gris claro)
    draw_set_color(make_color_rgb(30, 30, 30)); // Fondo
    draw_rectangle(_xx, _yy, _xx + slot_size, _yy + slot_size, false);
    
    draw_set_color(c_dkgray); // Borde
    draw_rectangle(_xx, _yy, _xx + slot_size, _yy + slot_size, true);
    
    // B. Dibujar el ITEM si existe
    var _data = inventory[i];
    
    if (_data != noone) {
        var _info = global.item_db[$ _data.id];
        
        // Dibujar Sprite centrado en el slot
        var _spr = _info.sprite;
        var _scale = (slot_size - 8) / sprite_get_width(_spr); // Ajuste automático de tamaño
        if (_scale > 1) _scale = 1; // Que no se haga gigante
        
        // Asumiendo origen Middle Center del sprite
        draw_sprite_ext(_spr, 0, _xx + slot_size/2, _yy + slot_size/2, _scale, _scale, 0, c_white, 1);
        
        // Dibujar Cantidad (Stack)
        if (_data.cantidad > 1) {
            draw_set_color(c_white);
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            draw_text_transformed(_xx + slot_size - 2, _yy + slot_size - 2, string(_data.cantidad), 0.8, 0.8, 0);
        }
    }
}

// Resetear alineación
draw_set_halign(fa_left);
draw_set_valign(fa_top);