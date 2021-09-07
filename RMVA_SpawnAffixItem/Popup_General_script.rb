$imported = {} if $imported == nil
$imported["H87_Popup"] = true
#===============================================================================
# Sistema Popup di Holy87
# Versione 1.1
#===============================================================================
# Questo script permette di mostrare in modo dinamico popup multipli per
# l'acquisizione o lo smarrimento di oro e oggetti, quando si ottiene un lev-up.
# Non solo, ma è possibile anche creare popup personalizzati per le più
# svariate situazioni. Basta mettere semplicemente in un evento, un Chiama
# Script con:
# Popup.show("messaggio")
# Oppure
# Popup.show("Messaggio",x) dove x sta all'id dell'icona
# oppure ancora
# Popup.show("Messaggio",x,[R,G,B,S]) dove RGB sono le tonalità, S la saturazione.
#-------------------------------------------------------------------------------
# INSTALLAZIONE
# Installare sotto Materials, prima del Main. Importare una immagine come barra
# per i popup. Non ha importanza la grandezza, lo script adatterà il popup a
# seconda delle dimesioni dell'immagine.
# INFO compatibilità:
# *Classe Scene_Map
#  Alias: update, start, terminate
# *Classe Game_Party
#  Alias: gain_gold, gain_item
# *Classe Game_Actor
#  Sovrascrive: show_level_up
#===============================================================================
module H87_Popup
#-------------------------------------------------------------------------------
# CONFIGURAZIONE GENERALE
# Configura lo script nelle opzioni generiche.
#-------------------------------------------------------------------------------
  #Velocità di comparsa del popup. Numeri piccoli aumentano la velocità.
  Speed = 3
  #-----------------------------------------------------------------------------
  #Tempo in secondi, prima che il popup cominci a sparire.
  PTime = 4
  #-----------------------------------------------------------------------------
  #Velocità di sparizione del popup una volta che scade il tempo
  Fade = 4
  #-----------------------------------------------------------------------------
  #Coordinata Y del popup quando apparirà.
  #Se viene impostato in basso allo schermo, popup consecutivi creeranno una
  #pila che sale, altrimenti scenderà.
  Altezza = 355
  #-----------------------------------------------------------------------------
  #Grafica dell'immagine dello sfondo del popup
  Grafica = "BarraPopup"
  #-----------------------------------------------------------------------------
  #Distanza in pixel dal bordo sinistro dello schermo quando spunta il popup
  Distanzax = 5
  #Distanza in pixel dei popup consecutivi quando vengono messi in fila
  Distanzay = 3
  #-----------------------------------------------------------------------------
  #Imposta lo switch che verrà usato per attivare e disattivare i popup
  #automatici, nel caso tu voglia cambiare denaro e oggetti al giocatore senza
  #che se ne accorga.
  Switch = 797
#-------------------------------------------------------------------------------
# CONFIGURAZIONE SPECIFICA
# Configurazione specifica di attivazione, suono e colore di ogni tipo di popup
#-------------------------------------------------------------------------------
  # *Configurazione Oggetti
  #Seleziona il suono che verrà eseguito all'ottenimento dell'oggetto
  SuonoOggetto = "Item1"
  #Imposta la tonalità di colore del popup (Rosso, Verde, Blu e Saturazione)
  ItemPreso= [-50,0,70,0]
  #-----------------------------------------------------------------------------
  # *Configura l'ottenimento del denaro
  #Seleziona l'icona che verrà mostrata quando otterrai del denaro
  Iconaoro = 2112
  #Seleziona il suono che verrà eseguito all'ottenimento del denaro
  SuonoOro = "Shop"
  #Mostrare il popup quando si ottiene denaro?
  Mostra_OroU = true
  #Mostrare il popup quando si perde denaro?
  Mostra_OroD = true
  #Seleziona la tonalità di colore del popup quando si ottiene denaro
  GoldTone = [-50,70,0,10]
  #Seleziona la tonalità di colore del popup quando si perde denaro
  GoldPerso= [70,0,-50,50]
#-------------------------------------------------------------------------------
# FONT DI GIOCO
# Configurazione del carattere
#-------------------------------------------------------------------------------
  #Nome del font:
  FontName = "Friz Quadrata TT" #sostituire con "nomefont"
  FontSize = 14 #sostituire con un valore, ad es. 20
  FontOutline = true #false se non lo vuoi
  #-----------------------------------------------------------------------------
  # *Configura il livello superiore (Funziona solo se selezioni Mostra Level Up)
  # Mostrare il livello superiore con un popup, o con il metodo classico?
  MostraLevel = true
  # Mostrare i poteri appresi quando si sale di livello su mappa?
  MostraPoteri = true
  #Icona del livello superiore
  IconaLevel = 2689
  #Tonalità che viene mostrata al livello superiore
  LivSup      = [ 50, 50,100,0]
  #Tonalità che viene mostrata per i nuovi poteri appresi
  NuoveSkill  = [ 50, 50,50,0]
  #Suono che viene eseguito al livello superiore
  SuonoLevel = "Up1"
  #Testo dell'abilità appresa
  Learn = "appresa!"
  #-----------------------------------------------------------------------------
  # *Configura popup per switch e variabili (funziona solo in modalità Test)
  #Seleziona l'icona di switch e variabili
  Iconaswitch = 80
  #Seleziona la tonalità di colore
  SwitchTone = [0,0,0,255]
  #-----------------------------------------------------------------------------
#===============================================================================
# FINE CONFIGURAZIONE
# Modificare tutto ciò che c'è sotto può compromettere il corretto funzionamento
# dello script. Agisci a tuo rischio e pericolo!
#===============================================================================
end
#===============================================================================
# Modulo Popup
#===============================================================================
module Popup
  #-----------------------------------------------------------------------------
  # * mostra il popup
  #-----------------------------------------------------------------------------
  def self.show(testo, icona=0, tone=nil)
    SceneManager.scene.mostra_popup(testo, icona, tone) if SceneManager.scene_is?(Scene_Map)
  end
  #-----------------------------------------------------------------------------
  # * esegue un suono
  #-----------------------------------------------------------------------------
  def self.esegui(suono)
    RPG::SE.new(suono,80,100).play if SceneManager.scene_is?(Scene_Map)
  end
  #-----------------------------------------------------------------------------
  # * mostra l'oro in monete
  #-----------------------------------------------------------------------------
  def self.gold_show(money,tone)
    show(money,-1,tone)
  end
end

#===============================================================================
# Classe Scene_Map
#===============================================================================
class Scene_Map < Scene_Base
  include H87_Popup
  #-----------------------------------------------------------------------------
  # * Start
  #-----------------------------------------------------------------------------
  alias h87_pstart start
  def start
    h87_pstart
    if $popups.nil?
      $popups = []
      $oblo = Viewport.new(0,0,Graphics.width,Graphics.height)
    else
      $oblo.visible = true
    end
    print $popups
    $oblo.z = 255
  end
  #-----------------------------------------------------------------------------
  # * Update
  #-----------------------------------------------------------------------------
  alias h87_pupdate update
  def update
    h87_pupdate
    aggiorna_popups
  end
  #-----------------------------------------------------------------------------
  # * Aggiunge un nuovo popup finestra.viewport = $oblo
  #-----------------------------------------------------------------------------
  def mostra_popup(testo, icona=0, tone=nil)
    immagine = Sprite.new($oblo)
    immagine.bitmap = Cache.picture(Grafica)
    immagine.tone = Tone.new(tone[0],tone[1],tone[2],tone[3]) if tone != nil
    finestra = Window_Map_Popup.new(immagine.width,testo, icona)
    finestra.viewport = $oblo
    finestra.opacity = 0
    finestra.x = 0-finestra.width
    finestra.y = Altezza
    immagine.x = riposizionax(finestra,immagine)
    immagine.y = riposizionay(finestra,immagine)
    immagine.z = 50
    popup = [finestra,immagine,0,0]
    sposta_popup_su #sposta sopra tutti i popup già presenti
    $popups.push(popup)
  end
  #-----------------------------------------------------------------------------
  # * Calcola la posizione dell'immagine
  #-----------------------------------------------------------------------------
  def riposizionax(finestra,immagine)
    larg=(finestra.width-immagine.width)/2
    return finestra.x+larg
  end
  #-----------------------------------------------------------------------------
  # * Calcola la posizione dell'immagine
  #-----------------------------------------------------------------------------
  def riposizionay(finestra,immagine)
    alt=(finestra.height-immagine.height)/2
    return finestra.y+alt
  end
  #-----------------------------------------------------------------------------
  # * Aggiornamento
  #-----------------------------------------------------------------------------
  def aggiorna_popups
    muovi_popup
    fade_popup
  end
  #-----------------------------------------------------------------------------
  # * Muove i popup
  #-----------------------------------------------------------------------------
  def muovi_popup
    for i in 0..$popups.size-1
      break if $popups[i] == nil
      barra = $popups[i]
      finestra = barra[0]
      next if finestra.disposed?
      immagine = barra[1]
      tempo    = barra[2]
      prossimay= barra[3]
      x = finestra.x
      y = finestra.y
      metax = Distanzax
      if Altezza > Graphics.height/2
        metay = Altezza - Distanzay - prossimay
      else
        metay = Altezza + Distanzay + prossimay
      end
      finestra.x += (metax-x)/Speed
      finestra.y += (metay-y)/Speed
      tempo += 1
      immagine.x = riposizionax(finestra,immagine)
      immagine.y = riposizionay(finestra,immagine)
      if tempo > PTime*Graphics.frame_rate
        finestra.contents_opacity -= Fade
        immagine.opacity -= Fade
      end
      $popups[i] = [finestra,immagine,tempo, prossimay] #riassemblamento
    end
  end
  #-----------------------------------------------------------------------------
  # * Assegna la prossima coordinata Y
  #-----------------------------------------------------------------------------
  def sposta_popup_su
    for i in 0..$popups.size-1
      next if $popups[i][1].disposed?
      $popups[i][3]+=$popups[i][1].height+Distanzay
    end
  end
  #-----------------------------------------------------------------------------
  # * Terminate
  #-----------------------------------------------------------------------------
  alias h87_pterminate terminate
  def terminate
    h87_pterminate
    $oblo.visible = false
  end
  #-----------------------------------------------------------------------------
  # *Elimina i popup non più presenti
  #-----------------------------------------------------------------------------
  def fade_popup
    $popups.each do |popup|
      next if popup.nil?
      if popup[1].opacity == 0
        elimina_elemento(popup)
      end
    end
  end
end #scene_map

#===============================================================================
# Classe Window_Map_Popup
#===============================================================================
class Window_Map_Popup < Window_Base
  def initialize(larghezza,testo, icona=0)
    super(0,0,larghezza,48)
    self.z = 200
    @testo = testo
    @icona = icona
    refresh
  end
  #-----------------------------------------------------------------------------
  # * refresh della finestra
  #-----------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @icona < 0 and $imported["H87_Golds"]
      show_gold_popup
    else
      show_text_popup
    end
  end
  #-----------------------------------------------------------------------------
  # * mostra il testo del popup
  #-----------------------------------------------------------------------------
  def show_text_popup
    draw_icon(@icona,0,0)
    @icona == 0 ? d = 0 : d = 24
    self.contents.font.name = H87_Popup::FontName
    self.contents.font.size = H87_Popup::FontSize
    self.contents.font.outline = H87_Popup::FontOutline
    text = convert_escape_characters(@testo)
    text.gsub!(/\eC\[(\d+)\]/i,"")
    self.contents.draw_text(d,0,self.width-(self.padding*2)-d,line_height,text)
  end
  #-----------------------------------------------------------------------------
  # * mostra l'oro in monete
  #-----------------------------------------------------------------------------
  def show_gold_popup
    draw_currency_value(@testo.to_i, "", 0, 0, self.width-(self.padding*2))
  end
end #Scene_Map

#===============================================================================
# Classe Game_Party
#===============================================================================
class Game_Party < Game_Unit
  alias ottieni_oro gain_gold unless $@
  #-----------------------------------------------------------------------------
  # * Ottieni Oro
  #-----------------------------------------------------------------------------
  def gain_gold(amount)
    if $game_switches[H87_Popup::Switch] == false
      if amount> 0 and H87_Popup::Mostra_OroU
        Popup.color_set(nil)
        if $imported["H87_Golds"]
          Popup.gold_show(amount,H87_Popup::GoldTone)
        else
          Popup.show("+"+amount.to_s,H87_Popup::Iconaoro,H87_Popup::GoldTone)
        end
        Popup.esegui(H87_Popup::SuonoOro)
      end
      if amount < 0 and H87_Popup::Mostra_OroD
        Popup.color_set(nil)
        if $imported["H87_Golds"]
          Popup.gold_show(amount,H87_Popup::GoldPerso)
        else
          Popup.show(amount.to_s,H87_Popup::Iconaoro,H87_Popup::GoldPerso)
        end
        Popup.esegui(H87_Popup::SuonoOro)
      end
    end
    ottieni_oro(amount)
  end
  #-----------------------------------------------------------------------------
  # * Ottieni Oggetto
  #-----------------------------------------------------------------------------
  alias prendi_oggetto gain_item
  def gain_item(item, amount, include_equip = false)
    case item
    when RPG::Item
      oggetto = $data_items[item.id]
    when RPG::Armor
      oggetto = $data_armors[item.id]
    when RPG::Weapon
      oggetto = $data_weapons[item.id]
    end
    if amount > 0 and $game_switches[H87_Popup::Switch] == false and item != nil
      nome = oggetto.name
      icona = oggetto.icon_index
      testo = sprintf("%s x%d",nome,amount)
      Popup.show(testo,icona,H87_Popup::ItemPreso)
      Popup.esegui(H87_Popup::SuonoOggetto)
    end
    prendi_oggetto(item, amount, include_equip)
  end
end # Game_Party

#===============================================================================
# Classe Game_Actor
#===============================================================================
class Game_Actor < Game_Battler
  #-----------------------------------------------------------------------------
  # * Mostra Lv. Up
  #-----------------------------------------------------------------------------
  def display_level_up(new_skills)
    if SceneManager.scene_is?(Scene_Map) and H87_Popup::MostraLevel
      testo = sprintf("%s %s%2d!",@name,Vocab::level,@level)
      Popup.color_set(nil)
      Popup.show(testo,H87_Popup::IconaLevel,H87_Popup::LivSup)
      Popup.esegui(H87_Popup::SuonoLevel)
      if H87_Popup::MostraPoteri
        for skill in new_skills
          testo = sprintf("%s %s",skill.name,H87_Popup::Learn)
          Popup.color_set(nil)
          Popup.show(testo,skill.icon_index,H87_Popup::NuoveSkill)
        end
      end
    else
      $game_message.new_page
      $game_message.add(sprintf(Vocab::LevelUp, @name, Vocab::level, @level))
      new_skills.each do |skill|
        $game_message.add(sprintf(Vocab::ObtainSkill, skill.name))
      end
    end
  end
  
end # Game_Actor

#===============================================================================
# Classe Scene_Title
#===============================================================================
class Scene_Title < Scene_Base
  #-----------------------------------------------------------------------------
  # * eliminazione dei popup
  #-----------------------------------------------------------------------------
  alias h87_pop_start start unless $@
  def start
    unless $popups.nil?
      $popups.each do |i|
        elimina_elemento(i)
      end
      $oblo.dispose
      $popups = nil
      $oblo = nil
    end
    h87_pop_start
  end
end

#===============================================================================
# Classe Scene_Base
#===============================================================================
class Scene_Base
  #-----------------------------------------------------------------------------
  # *Dispone finestre e picture
  #-----------------------------------------------------------------------------
  def elimina_elemento(i)
    i[0].dispose unless i[0].disposed?
    i[1].dispose unless i[1].disposed?
    $popups.delete(i)
  end
end