module Popup
  def self.color_set(color)
    @color = color
  end

  def self.setted_color
    @color
  end
end

class Window_Map_Popup < Window_Base
  alias itemr_show_text_popup show_text_popup unless $@

  def show_text_popup
    color = Popup.setted_color
    if color
      change_color(color)
    end
    itemr_show_text_popup
    Popup.color_set(nil)
  end

  def color_from_array(array)
    Color.new(array[0], array[1], array[2])
  end
end

class Game_Party < Game_Unit
  def gain_item(item, amount, include_equip = false)
    prendi_oggetto(item, amount, include_equip)
    if amount > 0 and $game_switches[H87_Popup::Switch] == false and item != nil and !@lock_gain_popup
      icona = item.icon_index
      Popup.color_set(item.rarity_colour)
      testo = sprintf("%s x%d", item.name ,amount)
      Popup.show(testo,icona,H87_Popup::ItemPreso)
      Popup.esegui(H87_Popup::SuonoOggetto)
    end
    @lock_gain_popup = false
  end

  alias classic_add_instance_item add_instance_item

  def add_instance_item(item)
    if $game_switches[H87_Popup::Switch] == false
      icon = item.icon_index
      text = item.name
      Popup.color_set(item.rarity_colour)
      Popup.show(text, icon, H87_Popup::ItemPreso)
      Popup.esegui(H87_Popup::SuonoOggetto)
      @lock_gain_popup = true
    end
    classic_add_instance_item(item)
  end
end