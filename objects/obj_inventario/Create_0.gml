/// @description Configuración de la Mochila

// Propiedades
inventory_visible = false; // ¿Está abierto con TAB?
total_slots = 6;           // Cantidad de huecos en la mochila
col_slots = 3;             // Columnas (para dibujar 3x2)

// Espacio de UI
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();
slot_size = 64;   // Tamaño de cada cuadrito en pixeles
slot_sep = 10;    // Separación entre cuadros

// EL INVENTARIO (Array de Structs)
// Cada posición será: { id: "nombre_item", cantidad: 0 } o noone
inventory = array_create(total_slots, noone);

// --- FUNCIÓN PARA AGREGAR ITEMS ---
// Devuelve true si pudo guardar, false si está lleno
// --- FUNCIÓN PARA AGREGAR ITEMS (CON LÍMITE GLOBAL) ---
function add_item(_item_id, _amount) {
    var _db_item = global.item_db[$ _item_id];
    
    // ========================================================
    // PASO 0: VERIFICACIÓN DE LÍMITE TOTAL (CORRECCIÓN)
    // ========================================================
    
    // Verificamos si este item tiene un límite definido en la DB
    if (variable_struct_exists(_db_item, "limit_total")) {
        
        var _cantidad_actual_en_mochila = 0;
        
        // Recorremos la mochila para contar cuántos tenemos YA
        for (var k = 0; k < total_slots; k++) {
            var _slot_check = inventory[k];
            if (_slot_check != noone && _slot_check.id == _item_id) {
                _cantidad_actual_en_mochila += _slot_check.cantidad;
            }
        }
        
        // Si lo que tenemos + lo que vamos a recoger supera el límite...
        if (_cantidad_actual_en_mochila + _amount > _db_item.limit_total) {
            // ¡BLOQUEADO!
            show_debug_message("Límite de este item alcanzado.");
            return false; 
        }
    }
    
    // ========================================================
    // PASO 1: INTENTAR APILAR (Stacking Normal)
    // ========================================================
    for (var i = 0; i < total_slots; i++) {
        var _slot = inventory[i];
        
        if (_slot != noone && _slot.id == _item_id) {
            if (_slot.cantidad < _db_item.max_stack) {
                var _space = _db_item.max_stack - _slot.cantidad;
                var _to_add = min(_amount, _space);
                
                _slot.cantidad += _to_add;
                _amount -= _to_add;
                
                if (_amount == 0) return true; 
            }
        }
    }
    
    // ========================================================
    // PASO 2: BUSCAR HUECO VACÍO
    // ========================================================
    if (_amount > 0) {
        for (var i = 0; i < total_slots; i++) {
            if (inventory[i] == noone) {
                inventory[i] = {
                    id: _item_id,
                    cantidad: _amount
                };
                return true;
            }
        }
    }
    
    return false; // Inventario lleno (sin huecos)
}

// --- FUNCIÓN PARA GASTAR ITEMS ---
// Devuelve true si tenía el item y lo gastó
function consume_item(_item_id, _amount) {
    
    // Buscar el item
    for (var i = 0; i < total_slots; i++) {
        var _slot = inventory[i];
        
        if (_slot != noone && _slot.id == _item_id) {
            
            // ¿Tenemos suficientes?
            if (_slot.cantidad >= _amount) {
                _slot.cantidad -= _amount;
                
                // Si llega a 0, vaciamos el slot
                if (_slot.cantidad <= 0) {
                    inventory[i] = noone;
                }
                return true; // Éxito
            }
        }
    }
    return false; // No tenías el item
}