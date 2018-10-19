#=============================================================================#
#   Extended Equipment Comparison Info                                        #
#   Version: 1.0.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2018.10.21                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported["COMP_EECI"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2018.10.19: Script completed                                             #
# -- 2018.10.16: Received commission and started                              #
#                                                                             #
#=============================================================================#
#                       ** End-User License Agreement **                      #
#-----------------------------------------------------------------------------#
# ┌─────────────────────────────────────────────────────────────────────────┐ #
# │         ** THIS IS A PAID SCRIPT, RE-DISTRIBUTE WITH CAUTION! **        │ #
# └─────────────────────────────────────────────────────────────────────────┘ #
#  1. Copyright and Redistribution:                                           #
#       All codes were written by me(Compeador), and you(the user) may edit   #
#  the code for your own need without permission (duh).                       #
#  Redistribute this script must agreed by VaiJack8, who commissioned this    #
#  script, and you must share the original version released by the author     #
#  without edits with credits.                                                #
#   If you edited the scripts and claimed it as your own, this will resulted  #
#  in copywrite law violation and also proves you're an a$$hole.              #
#                                                                             #
# 2. Service Information:                                                     #
#       I only responsible for the edits requested by VaiJack8(the client).   #
# If you got this script from the redistribution, I'm not responsible for any #
# bug and malfunction occurred in your project.                               #
#                                                                             #
# *You can still try to request me tho, but I won't 100% guaranteed for reply #
#=============================================================================#
#                              ** User Manual **                              #
#-----------------------------------------------------------------------------#
# > Introduction:                                                             #
#       This script will change the display of original parameter comparison  #
# in Equip Scene when changing the equipments, instead of showing default     #
# paramters, this script will only show changed parameters, including crit.   #
# evasion...etc.                                                              #
#   Most of editable option is in the module below, read the comments to know #
# what's it doing and how to adjust them for your needs.                      #
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > YEA Equip Engine is required                                            #
#   > Support comparison with 'Equipment Set Bonuses' by Modern Algebra       #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#                                                                             #
#   This script 99% will working if and only if in RPG Maker VX Ace. Also,    #
# this is only sutiable for the project uses default RM's parameters/features #
# that can be seen in database. On the other words, if you have tons of       #
# custom parameter and other features, this script may not works well.        #
#=============================================================================#

# Enable this script?
COMP_EECI_Enable = true

if COMP_EECI_Enable && !$imported["YEA-AceEquipEngine"]
  info = "Yanfly's Equip Engine is not detected, please make sure the script\n" +
         "is placed correctly.\n" +
         "The Equipment Extend Comparison Information will be disabled."
  msgbox(info)
  COMP_EECI_Enable = false
end

if COMP_EECI_Enable
#=============================================================================
# * Module of this script
#=============================================================================
module COMP
  #-------------------------------------------------------------------------
  # Abbr. of Extended Equipment Comparison Information
  module EECI
    #--------------------------------------------------------------------------
    # * Constants (Features) from Game_BattlerBase
    # * Don't edit this unless you know what you're doing
    #--------------------------------------------------------------------------
    FEATURE_ELEMENT_RATE    =   Game_BattlerBase::FEATURE_ELEMENT_RATE    # Element Rate
    FEATURE_DEBUFF_RATE     =   Game_BattlerBase::FEATURE_DEBUFF_RATE     # Debuff Rate
    FEATURE_STATE_RATE      =   Game_BattlerBase::FEATURE_STATE_RATE      # State Rate
    FEATURE_STATE_RESIST    =   Game_BattlerBase::FEATURE_STATE_RESIST    # State Resist
    FEATURE_PARAM           =   Game_BattlerBase::FEATURE_PARAM           # Parameter
    FEATURE_XPARAM          =   Game_BattlerBase::FEATURE_XPARAM          # Ex-Parameter
    FEATURE_SPARAM          =   Game_BattlerBase::FEATURE_SPARAM          # Sp-Parameter
    FEATURE_ATK_ELEMENT     =   Game_BattlerBase::FEATURE_ATK_ELEMENT     # Atk Element
    FEATURE_ATK_STATE       =   Game_BattlerBase::FEATURE_ATK_STATE       # Atk State
    FEATURE_ATK_SPEED       =   Game_BattlerBase::FEATURE_ATK_SPEED       # Atk Speed
    FEATURE_ATK_TIMES       =   Game_BattlerBase::FEATURE_ATK_TIMES       # Atk Times+
    FEATURE_STYPE_ADD       =   Game_BattlerBase::FEATURE_STYPE_ADD       # Add Skill Type
    FEATURE_STYPE_SEAL      =   Game_BattlerBase::FEATURE_STYPE_SEAL      # Disable Skill Type
    FEATURE_SKILL_ADD       =   Game_BattlerBase::FEATURE_SKILL_ADD       # Add Skill
    FEATURE_SKILL_SEAL      =   Game_BattlerBase::FEATURE_SKILL_SEAL      # Disable Skill
    FEATURE_EQUIP_WTYPE     =   Game_BattlerBase::FEATURE_EQUIP_WTYPE     # Equip Weapon
    FEATURE_EQUIP_ATYPE     =   Game_BattlerBase::FEATURE_EQUIP_ATYPE     # Equip Armor
    FEATURE_EQUIP_FIX       =   Game_BattlerBase::FEATURE_EQUIP_FIX       # Lock Equip
    FEATURE_EQUIP_SEAL      =   Game_BattlerBase::FEATURE_EQUIP_SEAL      # Seal Equip
    FEATURE_SLOT_TYPE       =   Game_BattlerBase::FEATURE_SLOT_TYPE       # Slot Type
    FEATURE_ACTION_PLUS     =   Game_BattlerBase::FEATURE_ACTION_PLUS     # Action Times+
    FEATURE_SPECIAL_FLAG    =   Game_BattlerBase::FEATURE_SPECIAL_FLAG    # Special Flag
    FEATURE_COLLAPSE_TYPE   =   Game_BattlerBase::FEATURE_COLLAPSE_TYPE   # Collapse Effect
    FEATURE_PARTY_ABILITY   =   Game_BattlerBase::FEATURE_PARTY_ABILITY   # Party Ability
    # ---Feature Flags---
    FLAG_ID_AUTO_BATTLE     =   Game_BattlerBase::FLAG_ID_AUTO_BATTLE     # auto battle
    FLAG_ID_GUARD           =   Game_BattlerBase::FLAG_ID_GUARD           # guard
    FLAG_ID_SUBSTITUTE      =   Game_BattlerBase::FLAG_ID_SUBSTITUTE      # substitute
    FLAG_ID_PRESERVE_TP     =   Game_BattlerBase::FLAG_ID_PRESERVE_TP     # preserve TP
    #=====================================================================#
    # *                     v Free to Edit v                              #
    #=====================================================================#
    # * The next/last page keybind, edit the value for your own need.
    #---------------------------------------------------------------------
    Key_nextpage   = :RIGHT
    Key_lastpage   = :LEFT
    #---------------------------------------------------------------------
    # * Hide the hint if no need to turn pages
    Auto_Hide = true 
    #---------------------------------------------------------------------
    # * After how many second to hide the hint after hint is shown? 
    #   0 = never
    AutoHideTimer = 5 * Graphics.frame_rate
    #---------------------------------------------------------------------
    # * The hint window that display text about turning pages, uses 
    #   ""(double quote) if you don't want to show hint
    Hint_Text     = "Use L/R to turn status pages"

    Hint_Position = :BR_actor_status          # at bottom-right of actor status window
    #               :BR_equip_status          # at bottom-right of equipment status window
    #               [x_position, y_position]  # Custom window position

    #                           R ,  G ,  B , Opacity
    Hint_BackColor = Color.new(  0,   0,   0, 150)    # Back color of sprite
    Hint_TextColor = Color.new(255, 255, 255, 255)    # Text color
    Hint_Fontsize  = 20                       # Font size
    Hint_Opacity   = 255                      # Opacity of sprite
    Hint_Canva     = [300, 24]                # Max Width/Height of canvas
    #---------------------------------------------------------------------
    # * Text displayed when showing the comparison of set equipment bonus
    SetEquipmentTextStem = "Set bonus"
    SetEquipmentText = SetEquipmentTextStem + " [%s]:" # don't edit this
    #---------------------------------------------------------------------
    # * Id for standard param, chances are no need to edits
    FeatureNormalParam = -1
    #---------------------------------------------------------------------
    # * The param/feature considered to compare
    ComparisonTable = {        
      #    better not touch      edit the text for your need
      #    ↓              ↓                 ↓       
      # symbol        => [id,  display group text showed in comparison]
      :param          => [FeatureNormalParam, ''],                  # Basic parameter
      :xparam         => [FEATURE_XPARAM, ''],                      # Ex-Parameter
      :sparam         => [FEATURE_SPARAM, ''],                      # Sp-Parameter

      :param_rate     => [FEATURE_PARAM, 'Param multipler'],        # Parameter
      :special_flag   => [FEATURE_SPECIAL_FLAG, 'Special'],         # Special feature flag
      :element_rate   => [FEATURE_ELEMENT_RATE, 'Element Rate'],    # Element Rate
      :debuff_rate    => [FEATURE_DEBUFF_RATE, 'Debuff Rate'],      # Debuff Rate
      :state_rate     => [FEATURE_STATE_RATE, 'State Rate'],        # State Rate
      :state_resist   => [FEATURE_STATE_RESIST, 'State Resist'],    # State Resist
      :atk_element    => [FEATURE_ATK_ELEMENT, 'Atk Element'],      # Atk Element
      :atk_state      => [FEATURE_ATK_STATE, 'Atk State'],          # Atk State
      :atk_speed      => [FEATURE_ATK_SPEED, 'Feature'],            # Atk Speed
      :atk_times      => [FEATURE_ATK_TIMES, 'Feature'],            # Atk Times+
      :stype_add      => [FEATURE_STYPE_ADD, 'Add Skill Type'],     # Add Skill Type
      :stype_seal     => [FEATURE_STYPE_SEAL, 'Disable Skill Type'],# Disable Skill Type
      :skill_add      => [FEATURE_SKILL_ADD, 'Add Skill'],          # Add Skill
      :skill_seal     => [FEATURE_SKILL_SEAL, 'Disable Skill'],     # Disable Skill
      :equip_wtype    => [FEATURE_EQUIP_WTYPE, 'Equip Weapon'],     # Equip Weapon
      :equip_atype    => [FEATURE_EQUIP_ATYPE, 'Equip Armor'],      # Equip Armor
      :equip_fix      => [FEATURE_EQUIP_FIX, 'Lock Equip'],         # Lock Equip
      :equip_seal     => [FEATURE_EQUIP_SEAL, 'Seal Equip'],        # Seal Equip
      :action_plus    => [FEATURE_ACTION_PLUS, 'Action Times+'],    # Action Times+
      :party_ability  => [FEATURE_PARTY_ABILITY, 'Party ability'],  # Party ability

      # kinda useless, so I didn't implement it.
      # :slot_type      => [FEATURE_SLOT_TYPE, 'Slot Type'],          # Slot Type
    }
    #---------------------------------------------------------------------
    # * Id for equipment set, perhaps not necessary to change
    FeatureEquipSet = -2
    #---------------------------------------------------------------------
    # * Compare with MA's equipment set diff
    if $imported[:MA_EquipmentSetBonuses]
      ComparisonTable[:equipset_plus] = [FeatureEquipSet, SetEquipmentText]
    end
    #---------------------------------------------------------------------
    MISC_text = 'Other' # the group text not in this order list
    #---------------------------------------------------------------------
    # * Display order of comparison group text, upper one displayed first
    TextDisplayOrder = [
      '',         # suggestion: better not touch this line
      'Feature',
      'Special',
      'Param multipler',
      'Element Rate',
      'Debuff Rate',
      'State Rate',
      'State Resist',
      'Atk Element',
      'Atk State',
      'Atk Speed',
      'Atk Times+',
      'Add Skill Type',
      'Disable Skill Type',
      'Add Skill',
      'Disable Skill',
      'Equip Weapon',
      'Equip Armor',
      'Lock Equip',
      'Seal Equip',
      'Slot Type',
      'Action Times+',
      'Party ability',
      MISC_text,
      SetEquipmentText,
    ]
    #---------------------------------------------------------------------
    # * Name display for each xparam
    XParamName = {
      0   => "HIT",  # HIT rate
      1   => "EVA",  # EVAsion rate
      2   => "CRI",  # CRItical rate
      3   => "CEV",  # Critical EVasion rate
      4   => "MEV",  # Magic EVasion rate
      5   => "MRF",  # Magic ReFlection rate
      6   => "CNT",  # CouNTer attack rate
      7   => "HRG",  # Hp ReGeneration rate
      8   => "MRG",  # Mp ReGeneration rate
      9   => "TRG",  # Tp ReGeneration rate
    }
    #---------------------------------------------------------------------
    # * Name display for each sparam
    SParamName = {
      0   => "TGR",  # TarGet Rate
      1   => "GRD",  # GuaRD effect rate
      2   => "REC",  # RECovery effect rate
      3   => "PHA",  # PHArmacology
      4   => "MCR",  # Mp Cost Rate
      5   => "TCR",  # Tp Charge Rate
      6   => "PDR",  # Physical Damage Rate
      7   => "MDR",  # Magical Damage Rate
      8   => "FDR",  # Floor Damage Rate
      9   => "EXR",  # EXperience Rate
    }
    #---------------------------------------------------------------------
    # * Name display for party ability
    PartyAbilityName = {
      0   => "Encounter Half",          # halve encounters
      1   => "Encounter None",          # disable encounters
      2   => "Cancel Surprise",         # disable surprise
      3   => "Raise Preemptive",        # increase preemptive strike rate
      4   => "Gold Double",             # double money earned
      5   => "Item Drop Rate Double",   # double item acquisition rate
    }
    #---------------------------------------------------------------------
    # * Name display for special feature
    SpecialFeatureName = {
      0 => "Auto Battle",
      1 => "Guard",
      2 => "Substitute",
      3 => "Preserve TP",
    }
    #--------------------------------------------------------------------------
    # * Feature name displayed at first of the line, before value comparison
    OtherFeatureName = {
      # feature id        => display name
      FEATURE_ATK_SPEED   => 'ASP',
      FEATURE_ATK_TIMES   => 'ATS+',
      FEATURE_ACTION_PLUS => '+%d:',
    }
    #---------------------------------------------------------------------
    # * prefix of single feature comparison
    FeatureAddText     = "+" + " %s"
    FeatureRemoveText  = "-" + " %s"
    FeatureEnableText  = "√" + " %s"
    FeatureDisableText = "X" + " %s"
    #---------------------------------------------------------------------
    # * The feature id that is actually not good
    InverseColorFeature = [
      FEATURE_STYPE_SEAL, FEATURE_SKILL_SEAL, FEATURE_EQUIP_FIX,
      FEATURE_EQUIP_SEAL,
    ]
    #---------------------------------------------------------------------
    # * The value of given feature id will disaply as percent
    PercentageFeaure = [
      FEATURE_ELEMENT_RATE, FEATURE_DEBUFF_RATE, FEATURE_STATE_RATE,
      FEATURE_PARAM, FEATURE_XPARAM, FEATURE_SPARAM, FEATURE_ATK_STATE,
      FEATURE_ACTION_PLUS, 
    ]
    #--------------------------------------------------------------------------
    # * Features that shows in status window when not comparing stuff
    CurFeatureShow = [
      FeatureNormalParam, FEATURE_PARTY_ABILITY, FEATURE_SKILL_ADD, FeatureEquipSet,
    ]
    #=====================================================================#
    # Please don't edit anything below unless you know what you're doing! #
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#

    # Strcuture holds compare result of each difference
    DiffInfo = Struct.new(:feature_id, :data_id, :value, :display_str, :group_text)
    # :feature_id  > what do you expect me to say?
    # :data_id     > data id in grouped feature, such as param
    # :delta       > value changed of that feature, in certain feature id is:
    #   true/false = add/remove after equip
    #
    # :display_str > Other text displayed
    # :group_text  > even need to explain?

    # Uses to fill the small blanks where not proper to write more lines
    DummyInfo = DiffInfo.new(nil, nil, nil, '')
    #--------------------------------------------------------------------------
    # * Mapping table for easier query
    StringTable     = {}   # feature_id => group_text
    FeatureIdTable  = {}   # group_text => feature_id
    DisplayOrder    = {}   # group_text => order
    DisplayIdOrder  = {}   # feature_id => order
    ComparisonTable.each do |symbol, info|
      StringTable[info[0]] = info[1]
      FeatureIdTable[info[1]] = info[0]
    end
    TextDisplayOrder.each_with_index do |str, i|
      DisplayOrder[str] = i
      DisplayIdOrder[FeatureIdTable[str]] = i
    end
  end
end

#==========================================================================
# ** RPG::BaseItem
#--------------------------------------------------------------------------
#   This class is the super class of all database classes
#==========================================================================
class RPG::BaseItem
  FEATURE_ACTION_PLUS   = 61              # Action Times+
  FEATURE_SPECIAL_FLAG  = 62              # Special Flag
  FEATURE_PARTY_ABILITY = 64              # Party Ability
  #--------------------------------------------------------------------------
  # * Get Feature Object Array (Feature Codes Limited)
  #--------------------------------------------------------------------------
  def features(code = nil)
    return @features if code.nil?
    @features.select {|ft| ft.code == code }
  end
  #--------------------------------------------------------------------------
  # * Get Feature Object Array (Feature Codes and Data IDs Limited)
  #--------------------------------------------------------------------------
  def features_with_id(code, id)
    @features.select {|ft| ft.code == code && ft.data_id == id }
  end
  #--------------------------------------------------------------------------
  # * Calculate Complement of Feature Values
  #--------------------------------------------------------------------------
  def features_pi(code, id)
    result = features_with_id(code, id).inject(1.0) {|r, ft| r *= ft.value }
  end
  #--------------------------------------------------------------------------
  # * Calculate Sum of Feature Values (Specify Data ID)
  #--------------------------------------------------------------------------
  def features_sum(code, id)
    features_with_id(code, id).inject(0.0) {|r, ft| r += ft.value }
  end
  #--------------------------------------------------------------------------
  # * Calculate Sum of Feature Values (Data ID Unspecified)
  #--------------------------------------------------------------------------
  def features_sum_all(code)
    features(code).inject(0.0) {|r, ft| r += ft.value }
  end
  #--------------------------------------------------------------------------
  # * Calculate Set Sum of Features
  #--------------------------------------------------------------------------
  def features_set(code)
    features(code).inject([]) {|r, ft| r |= [ft.data_id] }
  end
  #--------------------------------------------------------------------------
  # * Get Array of Additional Action Time Probabilities
  #--------------------------------------------------------------------------
  def action_plus_set
    features(FEATURE_ACTION_PLUS).collect {|ft| ft.value }
  end
  #--------------------------------------------------------------------------
  # * Determine if Special Flag
  #--------------------------------------------------------------------------
  def special_flag(flag_id)
    features(FEATURE_SPECIAL_FLAG).any? {|ft| ft.data_id == flag_id }
  end
  #--------------------------------------------------------------------------
  # * Determine Party Ability
  #--------------------------------------------------------------------------
  def party_ability(ability_id)
    features(FEATURE_PARTY_ABILITY).any? {|ft| ft.data_id == ability_id }
  end
  #--------------------------------------------------------------------------
end
#==============================================================================
# ** RPG::EquipItem
#==============================================================================
class RPG::EquipItem < RPG::BaseItem
  #---------------------------------------------------------------------------
  def param(id)
    return @params[id]
  end
  #---------------------------------------------------------------------------
end
#==============================================================================
# ** Sprite
#==============================================================================
class Sprite
  #---------------------------------------------------------------------------
  def show
    self.visible = true
    self
  end
  #---------------------------------------------------------------------------
  def hide
    self.visible = false
    self
  end
  #---------------------------------------------------------------------------
  def visible?
    return self.visible
  end
  #---------------------------------------------------------------------------
end
#==============================================================================
# ** Window_Base
#==============================================================================
class Window_Base < Window
  #---------------------------------------------------------------------------
  def active?
    return self.active
  end
  #---------------------------------------------------------------------------
  def visible?
    return self.visible
  end
  #---------------------------------------------------------------------------
end
#==============================================================================
# ** Module of this script
#==============================================================================
module COMP::EECI
  #--------------------------------------------------------------------------
  # * Dummy equipment for which compare side is nil
  Dummy = RPG::Weapon.new
  Dummy.features.clear
end
#==============================================================================
# ** Scene_Equip
#==============================================================================
class Scene_Equip < Scene_MenuBase
  #--------------------------------------------------------------------------
  Hint_Text      = COMP::EECI::Hint_Text
  Hint_Canva     = COMP::EECI::Hint_Canva
  Hint_Position  = COMP::EECI::Hint_Position
  Hint_BackColor = COMP::EECI::Hint_BackColor
  Hint_Fontsize  = COMP::EECI::Hint_Fontsize
  Hint_Opacity   = COMP::EECI::Hint_Opacity
  Hint_TextColor = COMP::EECI::Hint_TextColor
  #--------------------------------------------------------------------------
  # * alias: start
  #--------------------------------------------------------------------------
  alias start_eeci start
  def start
    start_eeci
    create_eeci_hint_window
  end
  #--------------------------------------------------------------------------
  alias update_eeci update
  def update
    update_autohide_timer if @eeci_hint_timer
    update_eeci
  end
  #--------------------------------------------------------------------------
  def update_autohide_timer
    return unless COMP::EECI::Auto_Hide
    return if COMP::EECI::AutoHideTimer == 0
    return if @eeci_hint_timer < 0
    return unless @hint_sprite.visible?
    @eeci_hint_timer -= 1 if @eeci_hint_timer >= 0
    update_eeci_hint_visibility if @eeci_hint_timer < 0
  end
  #--------------------------------------------------------------------------
  # * alias: slot [OK]
  #--------------------------------------------------------------------------
  alias on_slot_ok_eeci on_slot_ok
  def on_slot_ok
    item = @actor.equips.at(@slot_window.index)
    item = COMP::EECI::Dummy if item.nil?
    @status_window.set_template_item(item)
    on_slot_ok_eeci
  end
  #--------------------------------------------------------------------------
  def create_eeci_hint_window
    return if Hint_Text.length == 0

    @eeci_hint_timer = nil
    @hint_sprite = ::Sprite.new(@viewport)
    bw, bh = *Hint_Canva

    temp_bmp = Bitmap.new(bw,bh)
    temp_bmp.font.size = Hint_Fontsize
    bw = [temp_bmp.text_size(Hint_Text).width + 4, bw].min
    temp_bmp.dispose; temp_bmp = nil;

    @hint_sprite.bitmap = Bitmap.new(bw, bh)
    sx, sy = 0, 0
    if Hint_Position.is_a?(Array)
      sx, sy = *Hint_Position
    elsif Hint_Position == :BR_actor_status
      sx = @actor_window.x + @actor_window.width  - bw
      sy = @actor_window.y + @actor_window.height - bh
    elsif Hint_Position == :BR_equip_status
      sx = @status_window.x + @status_window.width - bw
      sy = @status_window.y + @status_window.height - bh
    end
    @hint_sprite.x, @hint_sprite.y = sx, sy;
    @hint_sprite.opacity = Hint_Opacity

    @hint_sprite.bitmap.font.size = Hint_Fontsize
    @hint_sprite.bitmap.font.color.set(Hint_TextColor)
    @hint_sprite.bitmap.fill_rect(0, 0, bw, bh, Hint_BackColor)
    @hint_sprite.bitmap.draw_text(2, 0, bw, bh, Hint_Text)
    @hint_sprite.z = @viewport.z
    
    update_eeci_hint_visibility
  end
  #--------------------------------------------------------------------------
  def update_eeci_hint_visibility
    return unless @hint_sprite
    return @hint_sprite.show if !COMP::EECI::Auto_Hide
    return @hint_sprite.hide if @eeci_hint_timer && @eeci_hint_timer < 0

    if @status_window.nil? || @item_window.nil? || !@status_window.visible?
      @hint_sprite.hide
      return
    end
    
    if @item_window.active?
      if @status_window.pages.size > @status_window.line_max
        @hint_sprite.show
        @eeci_hint_timer = COMP::EECI::AutoHideTimer unless @eeci_hint_timer
      else
        @hint_sprite.hide
      end
    else
      if @status_window.base_pages.size > @status_window.line_max
        @hint_sprite.show
        @eeci_hint_timer = COMP::EECI::AutoHideTimer unless @eeci_hint_timer
      else
        @hint_sprite.hide
      end
    end
  end
  #--------------------------------------------------------------------------
  alias :terminate_eeci :terminate
  def terminate
    @hint_sprite.dispose if @hint_sprite
    terminate_eeci
  end
end
#==============================================================================
# ** Window_EquipItem
#==============================================================================
class Window_EquipItem < Window_ItemList
  #--------------------------------------------------------------------------
  # * alias: update help
  #--------------------------------------------------------------------------
  alias update_help_eeci update_help
  def update_help
    @status_window.set_compare_item(item) if @actor && @status_window
    update_help_eeci
  end
end
#==============================================================================
# ** Window_EquipSlot
#==============================================================================
class Window_EquipSlot < Window_Selectable
  #---------------------------------------------------------------------------
  # * alias: refresh
  #---------------------------------------------------------------------------
  alias refresh_eeci refresh
  def refresh
    refresh_eeci
    return unless @status_window
    @status_window.set_base_actor(@actor)
    @status_window.collect_current_feature
    @status_window.draw_current_feature
  end
end
#==============================================================================
# ** Window_EquipStatus
#==============================================================================
class Window_EquipStatus < Window_Base
  include COMP::EECI
  EQS_Enable = $imported[:MA_EquipmentSetBonuses]
  #---------------------------------------------------------------------------
  # * Instance variables
  #---------------------------------------------------------------------------
  attr_reader :template_item, :compare_item, :base_actor, :feature_cache
  attr_reader :pages, :page_index, :base_pages
  #---------------------------------------------------------------------------
  # * Alias method: initialize
  #---------------------------------------------------------------------------
  alias init_eeci initialize
  def initialize(*args)
    @line_max       = nil   # Cache max line for faster query
    @feature_cache  = {}    # Cache feature value for faster query
    @pages          = []    # Comparison result array
    @base_pages     = []    # Actor current status array
    @page_index     = 0     # Current page index
    @base_actor     = nil   # For caching paramters
    @fiber          = nil   # Coroutine fiber
    @cw = nil               # Contents width, for window arrows hacks
    collect_compare_priority
    init_eeci(*args)
    @ori_contents_width = width - standard_padding * 2  # the 'real' contents width
    @visible_height = height
  end
  #---------------------------------------------------------------------------
  # * Comparsion priority according to display order
  #--------------------------------------------------------------------------
  def collect_compare_priority
    @compare_quque = []
    @compare_quque = ComparisonTable.sort_by{|k, dar|
      DisplayOrder[StringTable[dar.first]] ? DisplayOrder[StringTable[dar.first]] : DisplayOrder[MISC_text]
    }.collect{|p| p[0]}
  end
  #---------------------------------------------------------------------------
  # * Dummy method, does nothing
  #---------------------------------------------------------------------------
  def pass(*args, &block)
  end
  #---------------------------------------------------------------------------
  # * Max lines can be displayed in window at once
  #--------------------------------------------------------------------------
  def line_max
    return @line_max if @line_max
    return @line_max = contents_height / line_height
  end
  #---------------------------------------------------------------------------
  # * Alias method: update
  #---------------------------------------------------------------------------
  alias update_eeci update
  def update
    update_eeci
    update_page
  end
  #---------------------------------------------------------------------------
  # * update page next/last
  #---------------------------------------------------------------------------
  def update_page
    if Input.trigger?(Key_nextpage)
      next_page
    elsif Input.trigger?(Key_lastpage) && @page_index > 0
      last_page
    end
  end
  #---------------------------------------------------------------------------
  def next_page
    current_pages = @temp_actor.nil? ? @base_pages : @pages
    next_page = @page_index + 1
    resume_comparison if current_pages[next_page * line_max].nil? && !compare_over?
    if current_pages[next_page * line_max]
      # pre-compare next page if coroutine is still running
      resume_comparison unless compare_over?
      @page_index = next_page
      update_arrows(current_pages)
      draw_page(@temp_actor.nil?, @page_index)
    end
  end
  #---------------------------------------------------------------------------
  def last_page
    current_pages = @temp_actor.nil? ? @base_pages : @pages
    @page_index -= 1
    update_arrows(current_pages)
    draw_page(@temp_actor.nil?, @page_index)
  end
  #---------------------------------------------------------------------------
  def contents_width
    return super if @cw.nil?
    return @cw
  end
  #---------------------------------------------------------------------------
  # * Determine window arrow display
  #---------------------------------------------------------------------------
  def update_arrows(current_pages)
    @dx = 0
    self.ox = 0
    offset = standard_padding * 4
    @cw = @ori_contents_width
    lv = true if @page_index > 0
    rv = current_pages[(@page_index + 1) * line_max].nil? ? false : true
    if lv # show left arrow
      @cw += offset
      @dx     = offset
      self.ox = offset
    end
    @cw += offset if rv # show right arrow
    create_contents
  end
  #---------------------------------------------------------------------------
  def compare_over?
    @fiber == nil
  end
  #---------------------------------------------------------------------------
  def resume_comparison
    return if @fiber.nil?
    begin
      @fiber.resume
    rescue FiberError => e
      @fiber = nil
    end
    SceneManager.scene.update_eeci_hint_visibility
  end
  #---------------------------------------------------------------------------
  def set_template_item(item)
    return if @template_item == item
    @template_item = item
    @template_item = item.nil? ? Dummy : item
  end
  #---------------------------------------------------------------------------
  def set_compare_item(item)
    return if @compare_item == item
    @compare_item = item.nil? ? Dummy : item
  end
  #---------------------------------------------------------------------------
  def set_base_actor(actor)
    return if @base_actor == actor
    @feature_cache.clear
    @base_actor = actor
  end
  #---------------------------------------------------------------------------
  # * Overwrite method: actor=
  #---------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    collect_current_feature
    refresh
  end
  #---------------------------------------------------------------------------
  # * Overwrite method: refresh
  #---------------------------------------------------------------------------
  def refresh
    contents.clear
    @cw = nil
    @pages      = []
    @page_index =  0
    return unless @actor
    start_compare(:diff) if @temp_actor
    stage = (@temp_actor) ? :diff : :current
    resume_comparison
    draw_compare_result(stage == :current)
    SceneManager.scene.update_eeci_hint_visibility
  end
  #---------------------------------------------------------------------------
  def collect_current_feature
    return unless @actor
    start_compare(:current, true)
  end
  #---------------------------------------------------------------------------
  def start_compare(stage = :diff, restart = false)
    if stage == :diff
      save_fiber if !compare_over?
      @fiber = Fiber.new{compare_diffs(stage)}
    elsif stage == :current
      if restart
        release_fiber
        @current_feature = {}
        @base_pages      = []
        @fiber = Fiber.new{compare_diffs(stage)}
      elsif @saved_fiber
        load_fiber
      end
    else
      raise ArgumentError, "Invalid stage symbol (#{stage})"
    end
    resume_comparison
  end
  #---------------------------------------------------------------------------
  def save_fiber
    @saved_fiber = @fiber
  end
  #---------------------------------------------------------------------------
  def load_fiber
    @fiber = @saved_fiber
    release_fiber
  end
  #---------------------------------------------------------------------------
  def release_fiber
    @saved_fiber = nil
  end
  #---------------------------------------------------------------------------
  def process_compare_break(stage)
    @current_line_number = 0
    @draw_break = true
    @showed_group = {}
    Fiber.yield
  end
  #---------------------------------------------------------------------------
  def compare_diffs(stage = :diff)
    return if line_max < 2
    set_compare_item(Dummy) if @compare_item.nil? && stage != :current
    en_prefix   = [FeatureDisableText, FeatureEnableText]  
    @current_line_number = 0 unless stage == :eqset
    last_id = nil
    @showed_group = {}
    @compare_quque.each do |symbol|
      feature_id  = ComparisonTable[symbol].at(0)
      @current_group_text = ComparisonTable[symbol].at(1) || ''
      case symbol
      when :param;        compare_param(stage);
      when :param_rate;   compare_valued_feature(stage,feature_id, true)
      when :xparam;       compare_features_sum(stage,feature_id);
      when :sparam;       compare_features_pi(stage,feature_id);
      when :debuff_rate;  compare_valued_feature(stage, feature_id, true);
      when :skill_add;    compare_features_set(stage,feature_id);
      when :skill_seal;   compare_features_set(stage,feature_id, en_prefix.reverse);
      when :element_rate; compare_features_pi(stage,feature_id);
      when :atk_element;  compare_features_set(stage,feature_id);
      when :atk_state;    compare_valued_feature(stage,feature_id, false);
      when :state_rate;   compare_valued_feature(stage,feature_id, true);
      when :state_resist; compare_features_set(stage,feature_id);
      when :stype_seal;   compare_features_set(stage,feature_id, en_prefix.reverse);
      when :stype_add;    compare_features_set(stage,feature_id, en_prefix);
      when :atk_speed;    compare_features_sum(stage,feature_id);
      when :atk_times;    compare_features_sum(stage,feature_id);
      when :action_plus;  compare_action_plus(stage,feature_id);
      when :special_flag; compare_special_flag(stage,feature_id);
      when :party_ability;compare_party_ability(stage,feature_id);
      when :equip_fix;    compare_features_set(stage, feature_id, en_prefix.reverse);
      when :equip_seal;   compare_features_set(stage, feature_id, en_prefix.reverse);
      when :equip_wtype;  compare_features_set(stage, feature_id);
      when :equip_atype;  compare_features_set(stage, feature_id);
      end
      process_compare_break(stage) if @current_line_number >= line_max && !@draw_break
      if EQS_Enable && stage != :eqset && feature_id == FeatureEquipSet
        collect_equipment_set_diff(stage == :current)
      end
      last_id = feature_id
      @draw_break = false
      process_compare_break(stage) if @current_line_number >= line_max && !@draw_break
    end # ComparisonTable.each
  end
  #---------------------------------------------------------------------------
  def get_cache_feature(id, method, *args, &block)
    return @feature_cache[id] if @feature_cache[id]
    return unless @base_actor
    return (@feature_cache[id] = @base_actor.send(method, *args, &block))
  end
  #---------------------------------------------------------------------------
  def hash_feature_idx(feature_id, index = 0)
    return index * 10000 + feature_id
  end
  #---------------------------------------------------------------------------
  def push_new_comparison(stage, info)
    push_group_info(stage, info)
    
    if stage == :current || (stage == :eqset && @last_stage == :current)
      @base_pages << info
    else
      @pages << info
    end
    @current_line_number += 1
    if @current_line_number >= line_max
      process_compare_break(stage)
    end
  end
  #---------------------------------------------------------------------------
  def push_group_info(stage, info)
    str = []
    # push equipment set name if this is a feature of that
    str.push(sprintf(SetEquipmentText, @set_bonus_item.name)) if @set_bonus_item
    str.push(@current_group_text)
    ori_group = str.dup
    str.select!{|s| s.length > 0}
    str.select!{|s| !@showed_group[s]}

    reserve_line  = str.size
    reserve_line += 2 if str.size > 0

    if @current_line_number + reserve_line > line_max
      # Stocking with blank infos if no much space left
      (line_max - @current_line_number).times do |_|
        if stage == :current || (stage == :eqset && @last_stage == :current)
          @base_pages.push(DummyInfo)
        else
          @pages.push(DummyInfo)
        end
      end
      process_compare_break(stage)
      str = ori_group
    end

    # Push group text line
    str.each do |s|
      @showed_group[s] = true
      @current_line_number += 1
      duminfo = DummyInfo.dup; duminfo.group_text = s;
      if stage == :current || (stage == :eqset && @last_stage == :current)
        @base_pages.push(duminfo)
      else
        @pages.push(duminfo)
      end
    end # each group text
  end
  #---------------------------------------------------------------------------
  def compare_param(stage)
    feature_id = FeatureNormalParam
    ar = get_feature_array(feature_id)
    len = ar.size
    len.times do |i|
      str = get_feature_name(feature_id, i)
      # Show current actor feature status
      if stage == :current
        v = @actor.param(i)
        push_new_comparison(stage, DiffInfo.new(feature_id,i,[v,v],str))
        next
      # Comparison
      else
        a = @compare_item.param(i)
        b = @template_item.param(i)
        next if a - b == 0
        base = (get_cache_feature(i, :param, i) || 0)
        a += base
        b += base
        push_new_comparison(stage, DiffInfo.new(feature_id, i, [a,b], str))
      end
    end
  end
  #---------------------------------------------------------------------------
  def compare_features_sum(stage,feature_id)
    ar = get_feature_array(feature_id); len = ar.size;
    if len == 0
      str = get_feature_name(feature_id)
      # Show current actor feature status
      if stage == :current
        return unless CurFeatureShow.include?(feature_id)
        v = @actor.features_sum_all(feature_id)
        return if v == 0
        push_new_comparison(stage, DiffInfo.new(feature_id,0,[v,v],str))
        return
      else
        # Comparison
        a = @compare_item.features_sum_all(feature_id)
        b = @template_item.features_sum_all(feature_id)
        delta = (a - b)
        delta = delta.round(2) if delta.is_a?(Float)
        return if delta == 0
        base = (get_cache_feature(feature_id, :features_sum_all, feature_id) || 0)
        a += base
        b += base
        push_new_comparison(stage, DiffInfo.new(feature_id, 0, [a,b], str))
      end
    else
      len.times do |i|
        str = get_feature_name(feature_id, i)
        # Show current actor feature status
        if stage == :current
          return unless CurFeatureShow.include?(feature_id)
          v = @actor.features_sum(feature_id, i)
          next if v == 0
          push_new_comparison(stage, DiffInfo.new(feature_id,i,[v,v],str))
          next
        else
          # Comparison
          a = @compare_item.features_sum(feature_id, i)
          b = @template_item.features_sum(feature_id, i)
          delta = (a - b)
          delta = delta.round(2) if delta.is_a?(Float)
          next if delta == 0
          base = (get_cache_feature(hash_feature_idx(feature_id, i), :features_sum, feature_id, i) || 0)
          a += base
          b += base
          push_new_comparison(stage, DiffInfo.new(feature_id, i, [a,b], str))
        end
      end # len.times
    end # if len ==0
  end
  #---------------------------------------------------------------------------
  def compare_features_pi(stage, feature_id)
    ar = get_feature_array(feature_id); len = ar.size;
    len.times do |i|
      str = get_feature_name(feature_id, i)
      # Show current actor feature status
      if stage == :current
        return unless CurFeatureShow.include?(feature_id)
        v = @actor.features_pi(feature_id, i)
        next if v == 1.0
        push_new_comparison(stage, DiffInfo.new(feature_id,i,[v,v],str))
        next
      else
        # Comparison
        a = @compare_item.features_pi(feature_id, i)
        b = @template_item.features_pi(feature_id, i)
        delta = (a - b)
        delta = delta.round(2) if delta.is_a?(Float)
        next if delta == 0
        base = get_cache_feature(hash_feature_idx(feature_id, i), :features_pi, feature_id, i)
        base = 1 if base.nil?
        a *= base
        b *= base
        push_new_comparison(stage, DiffInfo.new(feature_id, i, [a,b], str))
      end
    end
  end
  #---------------------------------------------------------------------------
  def compare_features_set(stage, feature_id, prefix = [FeatureRemoveText, FeatureAddText])
    # Show current actor feature status
    if stage == :current
      return unless CurFeatureShow.include?(feature_id)
      feats = @actor.features_set(feature_id)
      feats.each do |i|
        str = sprintf(prefix[1], get_feature_name(feature_id, i))
        push_new_comparison(stage, DiffInfo.new(feature_id,i,true,str))
      end
      return
    else
      # Comparison
      after  = @compare_item.features_set(feature_id)
      before = @template_item.features_set(feature_id)
      
      diffs = []
      after.select{|id| !before.include?(id)}.each do |id|
        str = sprintf(prefix[1], get_feature_name(feature_id, id))
        diffs << DiffInfo.new(feature_id, id,  true, str)
      end
      
      before.select{|id| !after.include?(id)}.each do |id|
        str = sprintf(prefix[0], get_feature_name(feature_id, id))
        diffs << DiffInfo.new(feature_id, id, false, str)
      end

      diffs.each do |info|
        push_new_comparison(stage, info)
      end

    end
  end
  #---------------------------------------------------------------------------
  def compare_valued_feature(stage,feature_id, pi)
    # Show current actor feature status
    if stage == :current
      return unless CurFeatureShow.include?(feature_id)
      feats = @actor.features_set(feature_id)
      feats.each do |i|
        str = get_feature_name(feature_id, i)
        if pi
          v = @actor.features_pi(feature_id, i)
          next if v == 1
        else
          v = @actor.features_sum(feature_id, i)
          next if v == 0
        end
        push_new_comparison(stage, DiffInfo.new(feature_id,i,[v,v],str))
      end # each feat
      return
    else
      # Comparison
      after  = @compare_item.features_set(feature_id)
      before = @template_item.features_set(feature_id)
      prefix = [FeatureRemoveText, FeatureAddText]
      (after + before).uniq.sort.each do |id|
        if pi
          a = @compare_item.features_pi(feature_id, id)
          b = @template_item.features_pi(feature_id, id)
          method_symbol = :features_pi
        else
          a = @compare_item.features_sum(feature_id, id)
          b = @template_item.features_sum(feature_id, id)
          method_symbol = :features_sum
        end
        next if a - b == 0
        if pi
          base = get_cache_feature(hash_feature_idx(feature_id, id), method_symbol, feature_id, id)
          base = 1 if base.nil?
          a *= base
          b *= base
        else
          base = (get_cache_feature(hash_feature_idx(feature_id, id), method_symbol, feature_id, id) || 0)
          a += base
          b += base
        end
        str = get_feature_name(feature_id, id)
        push_new_comparison(stage, DiffInfo.new(feature_id, id, [a,b], str))
      end
    end
  end
  #---------------------------------------------------------------------------
  def compare_action_plus(stage,feature_id)
    # Show current actor feature status
    if stage == :current
      return unless CurFeatureShow.include?(feature_id)
      ar = @actor.action_plus_set.sort{|a,b| b <=> a}
      ar.each_with_index do |v,i|
        str = sprintf(get_feature_name(feature_id), i+1)
        push_new_comparison(stage, DiffInfo.new(feature_id,i,[v,v],str))
      end
      return
    else
      # Comparison
      after  = @compare_item.action_plus_set.sort{|a,b| b <=> a}
      before = @template_item.action_plus_set.sort{|a,b| b <=> a}
      return if after.size == 0 && before.size == 0
      n = [after.size, before.size].max
      n.times do |i|
        a = (after[i]  || 0)
        b = (before[i] || 0)
        str = sprintf(get_feature_name(feature_id), i+1)
        push_new_comparison(stage, DiffInfo.new(feature_id, 0, [a,b], str))
      end
    end
  end
  #---------------------------------------------------------------------------
  def compare_special_flag(stage,feature_id, prefix = [FeatureRemoveText, FeatureAddText])
    ar = SpecialFeatureName
    ar.each do |i, str|
      # Show current actor feature status
      if stage == :current
        return unless CurFeatureShow.include?(feature_id)
        en = @actor.special_flag(i)
        next unless en
        str = sprintf(prefix[1], str)
        push_new_comparison(stage, DiffInfo.new(feature_id,i,true,str))
        next
      else
        # Comparison
        before = @template_item.special_flag(i)
        after  = @compare_item.special_flag(i)
        next if before == after
        enabled = after ? 1 : 0
        str = sprintf(prefix[enabled], str)
        push_new_comparison(stage, DiffInfo.new(feature_id, i, after, str))
      end
    end
  end
  #---------------------------------------------------------------------------
  def compare_party_ability(stage,feature_id, prefix = [FeatureRemoveText, FeatureAddText])
    ar = PartyAbilityName
    ar.each do |i, str|
      # Show current actor feature status
      if stage == :current
        return unless CurFeatureShow.include?(feature_id)
        en = @actor.party_ability(i)
        next unless en
        str = sprintf(prefix[1], str)
        push_new_comparison(stage, DiffInfo.new(feature_id,i,true,str))
        next
      else
        # Comparison
        before = @template_item.party_ability(i)
        after  = @compare_item.party_ability(i)
        next if before == after
        enabled = after ? 1 : 0
        str = sprintf(prefix[enabled], str)
        push_new_comparison(stage, DiffInfo.new(feature_id, i, after, str))
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get Equipment Slot Name
  #--------------------------------------------------------------------------
  def slot_name(index)
    @actor ? Vocab::etype(@actor.equip_slots[index]) : ""
  end
  #---------------------------------------------------------------------------
  def get_group_text(feature_id)
    return StringTable[feature_id]
  end
  #---------------------------------------------------------------------------
  def get_feature_name(feature_id, index = nil)
    name = ''
    case feature_id
    when FEATURE_DEBUFF_RATE;   name = Vocab.param(index);
    when FeatureNormalParam;    name = Vocab.param(index);
    when FEATURE_ATK_ELEMENT;   name = $data_system.elements[index];
    when FEATURE_ELEMENT_RATE;  name = $data_system.elements[index];
    when FEATURE_PARAM;         name = Vocab.param(index);
    when FEATURE_XPARAM;        name = XParamName[index];
    when FEATURE_SPARAM;        name = SParamName[index];
    when FEATURE_SKILL_ADD;     name = ($data_skills[index].name rescue '');
    when FEATURE_SKILL_SEAL;    name = ($data_skills[index].name rescue '');
    when FEATURE_STATE_RATE;    name = ($data_states[index].name rescue '');
    when FEATURE_STATE_RESIST;  name = ($data_states[index].name rescue '');
    when FEATURE_ATK_STATE;     name = ($data_states[index].name rescue '');
    when FEATURE_EQUIP_WTYPE;   name = $data_system.weapon_types[index];
    when FEATURE_EQUIP_ATYPE;   name = $data_system.armor_types[index];
    when FEATURE_STYPE_ADD;     name = $data_system.skill_types[index];
    when FEATURE_STYPE_SEAL;    name = $data_system.skill_types[index];
    when FEATURE_PARTY_ABILITY; name = PartyAbilityName[index];
    when FEATURE_SPECIAL_FLAG;  name = SpecialFeatureName[index];
    when FEATURE_EQUIP_FIX;     name = slot_name(index);
    when FEATURE_EQUIP_SEAL;    name = slot_name(index);
    else
      return OtherFeatureName[feature_id] || ""
    end
    return name  || ''
  end
  #---------------------------------------------------------------------------
  def get_feature_array(feature_id)
    case feature_id
    when FeatureNormalParam;    return Array.new($data_system.terms.params.size);
    when FEATURE_ATK_ELEMENT;   return $data_system.elements;
    when FEATURE_ELEMENT_RATE;  return $data_system.elements;
    when FEATURE_PARAM;         return Array.new($data_system.terms.params.size);
    when FEATURE_DEBUFF_RATE;   return Array.new($data_system.terms.params.size);
    when FEATURE_XPARAM;        return Array.new(XParamName.size);
    when FEATURE_SPARAM;        return Array.new(SParamName.size);
    when FEATURE_SKILL_ADD;     return $data_skills;
    when FEATURE_SKILL_SEAL;    return $data_skills;
    when FEATURE_STATE_RATE;    return $data_states;
    when FEATURE_STATE_RESIST;  return $data_states;
    when FEATURE_ATK_STATE;     return $data_states;
    when FEATURE_EQUIP_WTYPE;   return $data_system.weapon_types;
    when FEATURE_EQUIP_WTYPE;   return $data_system.armor_types;
    when FEATURE_STYPE_ADD;     return $data_system.skill_types;
    when FEATURE_STYPE_SEAL;    return $data_system.skill_types;
    when FEATURE_PARTY_ABILITY; return PartyAbilityName;
    when FEATURE_SPECIAL_FLAG;  return SpecialFeatureName;
    when FEATURE_EQUIP_FIX;     return $data_system.terms.etypes;
    when FEATURE_EQUIP_SEAL;    return $data_system.terms.etypes;
    else
      return []
    end
  end
  #---------------------------------------------------------------------------
  def draw_current_feature
    resume_comparison
    draw_compare_result(true)
  end
  #---------------------------------------------------------------------------
  def draw_page(cur_feat, index)
    head = index * line_max
    rear = (index + 1) * line_max - 1
    # the lines for current page
    list = cur_feat ? @base_pages[head..[@base_pages.size-1, rear].min] : @pages[head..[@pages.size, rear].min]
    return if list.nil?
    contents.clear
    last_display_group = ''
    @comparing = !cur_feat

    dy = 0
    list.each_with_index do |info, i|
      feature_id = info.feature_id
      if (info.group_text || '').length > 0
        if EQS_Enable && info.group_text.match(SetEquipmentTextStem)
          draw_equipset_title(@dx, dy, info.group_text || '')
          dy += line_height
        elsif last_display_group != info.group_text
          last_display_group = info.group_text
          rect = Rect.new(@dx, dy, @ori_contents_width, line_height)
          draw_text(rect, info.group_text)
          dy += line_height
        end
      end
      next if info.feature_id.nil?
      draw_item(@dx, dy, info)
      dy += line_height
    end
  end
  #---------------------------------------------------------------------------
  def draw_compare_result(cur_feat = false)
    resume_comparison
    update_arrows(cur_feat ? @base_pages : @pages)
    draw_page(cur_feat, 0)
  end
  #---------------------------------------------------------------------------
  # * Draw the name of equipment set
  #---------------------------------------------------------------------------
  def draw_equipset_title(dx, dy, str)
    return if str.length == 0
    change_color(crisis_color)
    draw_text(dx, dy, @ori_contents_width, line_height, str)
    change_color(normal_color)
  end
  #---------------------------------------------------------------------------
  # * Overwrite: draw_item
  #---------------------------------------------------------------------------
  def draw_item(dx, dy, info)
    # YEA Equip Engine code
    if $imported["YEA-AceEquipEngine"]
      self.contents.font.size = YEA::EQUIP::STATUS_FONT_SIZE
      draw_background_colour(dx, dy)
    end

    # Draw feature add/remove
    if info.value == true || info.value == false
      a = (info.value ? 1 : 0)
      b = (info.value ? 0 : 1)
      # Inverse the color effect if feature is not good
      inverse = InverseColorFeature.include?(info.feature_id)
      
      if inverse
        a ^= 1; b ^= 1;
      end
      
      change_color(param_change_color(a - b))

      # draw skill change with the icon
      if [FEATURE_SKILL_ADD, FEATURE_SKILL_SEAL].include?(info.feature_id)
        draw_skill_change(dx + 2, dy, info)
      else
        draw_info_change(dx, dy, info.display_str)
      end
      change_color(normal_color)
    else
      draw_info_name(dx + 4, dy, info.display_str)
      draw_info_diff(dx, dy, info.value, PercentageFeaure.include?(info.feature_id))
    end
    reset_font_settings if $imported["YEA-AceEquipEngine"]
  end
  #---------------------------------------------------------------------------
  # * Draw add/remove/enable/disable text
  #---------------------------------------------------------------------------
  def draw_info_change(dx, dy, str)
    rect = Rect.new(dx, dy, @ori_contents_width-4, line_height)
    draw_text(rect, str, 2)
  end
  #---------------------------------------------------------------------------
  def draw_skill_change(dx, dy, info)
    str = info.display_str
    return draw_info_change(dx, dy, str) unless (info.data_id || 0) > 0
    text_width = self.contents.text_size(str).width
    dx = dx + @ori_contents_width - text_width - 34
    prefix = str[0]; str = str[1...str.length];
    rect = Rect.new(dx, dy, self.contents.text_size(prefix).width + 3, line_height)
    draw_text(rect, prefix)
    offset = rect.width + 24
    draw_icon($data_skills[info.data_id].icon_index, dx + rect.width, dy)
    rect.x += offset; rect.width = text_width;
    draw_text(rect, str)
  end
  #---------------------------------------------------------------------------
  def draw_info_name(dx, dy, str)
    change_color(system_color)
    draw_text(dx, dy, @ori_contents_width, line_height, str)
    change_color(normal_color)
  end
  #---------------------------------------------------------------------------
  def draw_info_diff(dx, dy, value, is_percent = false)
    dw = (@ori_contents_width + 54) / 2
    crect = Rect.new(dx, dy, dw, line_height)
    nrect = Rect.new(dx, dy, @ori_contents_width - 8, line_height)
    drx = dx + (@ori_contents_width + 54) / 2
    draw_diff_value(crect, value[1], is_percent) if @comparing
    draw_right_arrow(drx, dy)                    if @comparing
    change_color(param_change_color(value[0] - value[1]))
    draw_diff_value(nrect, value[0], is_percent)
    change_color(normal_color)
  end
  #---------------------------------------------------------------------------
  def draw_diff_value(rect, value, is_percent)
    str = value.to_s
    str = sprintf("%d\%", (value * 100).round(2).to_i) if is_percent
    draw_text(rect, str, 2)
  end
  #--------------------------------------------------------------------------
  def draw_background_colour(dx, dy)
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, @ori_contents_width - 2, line_height - 2)
    contents.fill_rect(rect, colour)
  end
  #--------------------------------------------------------------------------
#-#
  #---------------------------------------------------------------------------
  # * Compare the equipment set bonus
  #---------------------------------------------------------------------------
if $imported[:MA_EquipmentSetBonuses]
  #---------------------------------------------------------------------------
  # * Collect equipment set difference, current_only: collect currently
  #   activated equipment set.
  def collect_equipment_set_diff(current_only = false)
    return unless @actor
    before = @actor.maesb_sets || []
    feature_id = FeatureEquipSet
    return if current_only && before.size == 0
    btmp_item = @template_item ? @template_item.dup : nil
    @last_stage = current_only ? :current : :diff
    if current_only
      start_index = @base_pages.size
      bcmp_item = @compare_item ? @compare_item.dup : nil
      @template_item = Dummy
      before.each do |obj|
        @compare_item = obj
        @set_bonus_item = obj
        compare_diffs(:eqset)
      end
    else
      return unless @temp_actor
      after  = @temp_actor.maesb_sets || []
      bcmp_item = @compare_item ? @compare_item.dup : nil
      start_index = @pages.size
      @template_item = Dummy
      after.select{|obj| !before.include?(obj)}.each do |obj|
        @compare_item = obj
        @set_bonus_item = obj
        compare_diffs(:eqset)
      end
      @compare_item = Dummy
      before.select{|obj| !after.include?(obj)}.each do |obj|
        @pages << DummyInfo
        @template_item = obj
        @set_bonus_item = obj
        compare_diffs(:eqset)
      end
    end
    @last_stage = nil
    @set_bonus_item = nil
    @template_item = btmp_item
    @compare_item = bcmp_item
  end
end
  #---------------------------------------------------------------------------
#-#
end # class Window_EQ status
end # enable
