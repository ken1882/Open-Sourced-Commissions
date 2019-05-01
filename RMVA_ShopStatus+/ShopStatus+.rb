#=============================================================================#
#   Shop Item Status Plus                                                     #
#   Version: 1.0.1                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2019.04.30                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported["COMP_SISP"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2019.05.01: Fix slot name crash bug                                      #
# -- 2019.04.30: Start the script and completed                               #
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
#       This script replaces the item information window in shop scene,       #
# display the details of the item.                                            #
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > Place this script under my EquipComparsion script if you have it.       #
#   > Place this script under YEA's shop option script if you have it.        #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#                                                                             #
#   This script most of are the copies from my EECI script, so there're some  #
# variable/method name not changed.                                           #
#=============================================================================#

#=============================================================================
# * Module of this script
#=============================================================================
module COMP
  module ShopItemStatusPlus
    # Whether enable this script
    Enable = true

    # Text displayed when nothing to show
    NothingText = "No Specials"

    # if enabled and have my EquipComparsion script instlled, set to true and
    # this script will use EECI's settings instead of the one in this script
    UseEECITable = false
  end

  
  if !defined?(COMP::EECI) || !ShopItemStatusPlus::UseEECITable
  # Edit the stuff below if you don't have my EquipComparsion script, otherwise
  # just edit the variables in EECI script 
  module ShopItemStatusPlus
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
    # * Id for standard param, chances are no need to edits
    FeatureNormalParam = -1
    #---------------------------------------------------------------------
    # * The param/feature to show
    ComparisonTable = {        
      #    better not touch      edit the text for your need
      #    ↓              ↓                 ↓       
      # symbol        => [id,  display group text showed in comparison]

      # :param          => [FeatureNormalParam, ''],                  # Basic parameter
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
      FEATURE_EQUIP_SEAL, FEATURE_ELEMENT_RATE,
    ]
    #---------------------------------------------------------------------
    # * The value of given feature id will disaply as percent
    PercentageFeaure = [
      FEATURE_ELEMENT_RATE, FEATURE_DEBUFF_RATE, FEATURE_STATE_RATE,
      FEATURE_PARAM, FEATURE_XPARAM, FEATURE_SPARAM, FEATURE_ATK_STATE,
      FEATURE_ACTION_PLUS,
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
  end # module SISP
  # include the constants if EECI imported
  else
    module ShopItemStatusPlus
      include COMP::EECI
    end
  end
end

if COMP::ShopItemStatusPlus::Enable
#==========================================================================
# ** RPG::BaseItem
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
    result = features_with_id(code, id).inject(1.0){ |r, ft|
      r *= (ft.value == 0.0) ? 0.0000001 : ft.value
    }
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
# ■ Game_BattlerBase
#==============================================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Overwrite: features_pi with zero dirty hack
  #--------------------------------------------------------------------------
  def features_pi(code, id)
    features_with_id(code, id).inject(1.0) {|r, ft|
      r *= (ft.value == 0.0) ? 0.0000001 : ft.value
    }
  end
end
#==============================================================================
# ** Module of this script
#==============================================================================
module COMP::ShopItemStatusPlus
  #--------------------------------------------------------------------------
  # * Dummy equipment for which compare side is nil
  Dummy = RPG::Weapon.new
  Dummy.features.clear
end
#==============================================================================
# ** Scene_Shop
#==============================================================================
class Scene_Shop < Scene_MenuBase
end
#==============================================================================
# ** Window_ShopStatus
#==============================================================================
class Window_ShopStatus < Window_Base
  include COMP::ShopItemStatusPlus
  #---------------------------------------------------------------------------
  # * Instance variables
  #---------------------------------------------------------------------------
  attr_reader :feature_cache, :pages, :page_index, :base_pages
  #---------------------------------------------------------------------------
  # * Alias method: initialize
  #---------------------------------------------------------------------------
  alias init_sisp initialize
  def initialize(*args)
    @line_max       = nil   # Cache max line for faster query
    @feature_cache  = {}    # Cache feature value for faster query
    @pages          = []    # Comparison result array
    @page_index     = 0     # Current page index
    @fiber          = nil   # Coroutine fiber
    @cw = nil               # Contents width, for window arrows hacks
    collect_compare_priority
    init_sisp(*args)
    @ori_contents_width = width - standard_padding * 2  # the 'real' contents width
    @visible_height = height
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Draw Equipment Information
  #--------------------------------------------------------------------------
  def draw_equip_info(x, y)
    start_compare(true)
    resume_comparison
    draw_compare_result
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
  alias update_sisp update
  def update
    update_sisp
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
    current_pages = @pages
    next_page = @page_index + 1
    resume_comparison if current_pages[next_page * line_max].nil? && !compare_over?
    if current_pages[next_page * line_max]
      # pre-compare next page if coroutine is still running
      resume_comparison unless compare_over?
      @page_index = next_page
      update_arrows(current_pages)
      draw_page(@page_index)
    end
  end
  #---------------------------------------------------------------------------
  def last_page
    current_pages = @pages
    @page_index -= 1
    update_arrows(current_pages)
    draw_page(@page_index)
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
      @cw    += offset
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
  end
  #---------------------------------------------------------------------------
  # * Overwrite method: item=
  #---------------------------------------------------------------------------
  def item=(item)
    return if @item == item
    @item = item
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
    if @item.is_a?(RPG::EquipItem)
      # draw_equip_info(4, line_height * 2)
      draw_equip_info(4, 0)
    else
      @cw = @ori_contents_width # Restore contents width
      create_contents
      draw_possession(4, 0)
    end
  end
  #---------------------------------------------------------------------------
  def start_compare(restart = false)
    if restart
      release_fiber
      @current_feature = {}
      @pages           = []
      @fiber = Fiber.new{compare_diffs()}
    elsif @saved_fiber
      load_fiber
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
  def process_compare_break
    @current_line_number = 0
    @draw_break = true
    @showed_group = {}
    Fiber.yield
  end
  #---------------------------------------------------------------------------
  def compare_diffs
    return if line_max < 2

    en_prefix   = [FeatureDisableText, FeatureEnableText]  
    @current_line_number = 0
    last_id = nil

    @showed_group = {}
    @compare_quque.each do |symbol|
      feature_id  = ComparisonTable[symbol].at(0)
      @current_group_text = ComparisonTable[symbol].at(1) || ''
      case symbol
      when :param;        compare_param();
      when :param_rate;   compare_valued_feature(feature_id, true)
      when :xparam;       compare_features_sum(feature_id);
      when :sparam;       compare_features_pi(feature_id);
      when :debuff_rate;  compare_valued_feature(feature_id, true);
      when :skill_add;    compare_features_set(feature_id);
      when :skill_seal;   compare_features_set(feature_id, en_prefix.reverse);
      when :element_rate; compare_features_pi(feature_id);
      when :atk_element;  compare_features_set(feature_id);
      when :atk_state;    compare_valued_feature(feature_id, false);
      when :state_rate;   compare_valued_feature(feature_id, true);
      when :state_resist; compare_features_set(feature_id);
      when :stype_seal;   compare_features_set(feature_id, en_prefix.reverse);
      when :stype_add;    compare_features_set(feature_id, en_prefix);
      when :atk_speed;    compare_features_sum(feature_id);
      when :atk_times;    compare_features_sum(feature_id);
      when :action_plus;  compare_action_plus(feature_id);
      when :special_flag; compare_special_flag(feature_id);
      when :party_ability;compare_party_ability(feature_id);
      when :equip_fix;    compare_features_set(feature_id, en_prefix.reverse);
      when :equip_seal;   compare_features_set(feature_id, en_prefix.reverse);
      when :equip_wtype;  compare_features_set(feature_id);
      when :equip_atype;  compare_features_set(feature_id);
      end

      process_compare_break() if @current_line_number >= line_max && !@draw_break
      last_id = feature_id
      @draw_break = false
      process_compare_break() if @current_line_number >= line_max && !@draw_break
    end # ComparisonTable.each
  end
  #---------------------------------------------------------------------------
  def hash_feature_idx(feature_id, index = 0)
    return index * 10000 + feature_id
  end
  #---------------------------------------------------------------------------
  def push_new_comparison(info)
    push_group_info(info)
    
    @pages << info
    @current_line_number += 1
    if @current_line_number >= line_max
      process_compare_break
    end
  end
  #---------------------------------------------------------------------------
  def push_group_info(info)
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
        @pages.push(DummyInfo)
      end
      process_compare_break()
      str = ori_group
    end

    # Push group text line
    str.each do |s|
      @showed_group[s] = true
      @current_line_number += 1
      duminfo = DummyInfo.dup; duminfo.group_text = s;
      @pages.push(duminfo)
    end # each group text
  end
  #---------------------------------------------------------------------------
  def compare_param
    feature_id = FeatureNormalParam
    ar = get_feature_array(feature_id)
    len = ar.size
    len.times do |i|
      str = get_feature_name(feature_id, i)
      v = @item.param(i)
      push_new_comparison(DiffInfo.new(feature_id,i,[v,0],str))
    end
  end
  #---------------------------------------------------------------------------
  def compare_features_sum(feature_id)
    ar = get_feature_array(feature_id); len = ar.size;
    if len == 0
      str = get_feature_name(feature_id)
      v = @item.features_sum_all(feature_id)
      return if v == 0
      push_new_comparison(DiffInfo.new(feature_id,0,[v,0],str))
      return
    else
      len.times do |i|
        str = get_feature_name(feature_id, i)
        v = @item.features_sum(feature_id, i)
        next if v == 0
        push_new_comparison(DiffInfo.new(feature_id,i,[v,0],str))
      end # len.times
    end # if len ==0
  end
  #---------------------------------------------------------------------------
  def compare_features_pi(feature_id)
    ar = get_feature_array(feature_id); len = ar.size;
    len.times do |i|
      str = get_feature_name(feature_id, i)
      v = @item.features_pi(feature_id, i)
      next if v == 1.0
      push_new_comparison(DiffInfo.new(feature_id,i,[v, 1.0],str))
    end
  end
  #---------------------------------------------------------------------------
  def compare_features_set(feature_id, prefix = [FeatureRemoveText, FeatureAddText])
    feats = @item.features_set(feature_id)
    feats.each do |i|
      str = sprintf(prefix[1], get_feature_name(feature_id, i))
      push_new_comparison(DiffInfo.new(feature_id,i,true,str))
    end
  end
  #---------------------------------------------------------------------------
  def compare_valued_feature(feature_id, pi)
    feats = @item.features_set(feature_id)
    feats.each do |i|
      str = get_feature_name(feature_id, i)
      if pi
        v = @item.features_pi(feature_id, i)
        next if v == 1
      else
        v = @item.features_sum(feature_id, i)
        next if v == 0
      end
      default_value = pi ? 1 : 0
      push_new_comparison(DiffInfo.new(feature_id,i,[v,default_value],str))
    end # each feat
  end
  #---------------------------------------------------------------------------
  def compare_action_plus(feature_id)
    ar = @item.action_plus_set.sort{|a,b| b <=> a}
    ar.each_with_index do |v,i|
      str = sprintf(get_feature_name(feature_id), i+1)
      push_new_comparison(DiffInfo.new(feature_id,i,[v,0],str))
    end
  end
  #---------------------------------------------------------------------------
  def compare_special_flag(feature_id, prefix = [FeatureRemoveText, FeatureAddText])
    ar = SpecialFeatureName
    ar.each do |i, str|
      en = @item.special_flag(i)
      next unless en
      str = sprintf(prefix[1], str)
      push_new_comparison(DiffInfo.new(feature_id,i,true,str))
    end
  end
  #---------------------------------------------------------------------------
  def compare_party_ability(feature_id, prefix = [FeatureRemoveText, FeatureAddText])
    ar = PartyAbilityName
    ar.each do |i, str|
      en = @item.party_ability(i)
      next unless en
      str = sprintf(prefix[1], str)
      push_new_comparison(DiffInfo.new(feature_id,i,true,str))
    end
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
  def slot_name(idx)
    begin
      re = Vocab::etype($game_party.leader.equip_slots[idx])
      return re
    rescue Exception => e
      return ""
    end
  end
  #---------------------------------------------------------------------------
  def draw_current_feature
    resume_comparison
    draw_compare_result(true)
  end
  #---------------------------------------------------------------------------
  def draw_page(index)
    head = index * line_max
    rear = (index + 1) * line_max - 1
    # the lines for current page
    list = @pages[head..[@pages.size, rear].min]
    return if list.nil?
    contents.clear
    last_display_group = ''
    
    return draw_nothing_text if list.size == 0
    dy = 0
    list.each_with_index do |info, i|
      feature_id = info.feature_id
      if (info.group_text || '').length > 0 && last_display_group != info.group_text
        last_display_group = info.group_text
        rect = Rect.new(@dx, dy, @ori_contents_width, line_height)
        draw_text(rect, info.group_text)
        dy += line_height
      end
      next if info.feature_id.nil?
      draw_item(@dx, dy, info)
      dy += line_height
    end
  end
  #---------------------------------------------------------------------------
  def draw_nothing_text
    self.contents.draw_text(@dx, 4, @ori_contents_width, line_height, NothingText)
  end
  #---------------------------------------------------------------------------
  def draw_compare_result
    resume_comparison
    update_arrows(@pages)
    draw_page(0)
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
    if $imported["YEA-ShopOptions"]
      self.contents.font.size = YEA::SHOP::STATUS_FONT_SIZE
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
      draw_info_diff(dx, dy, info)
    end
    reset_font_settings if $imported["YEA-ShopOptions"]
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
  def draw_diff_value(rect, value, is_percent)
    str = value.to_s
    str = sprintf("%d\%", (value * 100).round(2).to_i) if is_percent
    draw_text(rect, str, 2)
  end
  #---------------------------------------------------------------------------
  def draw_info_diff(dx, dy, info)
    value = info.value
    is_percent = PercentageFeaure.include?(info.feature_id)

    dw = (@ori_contents_width + 54) / 2
    crect = Rect.new(dx, dy, dw, line_height)
    nrect = Rect.new(dx, dy, @ori_contents_width - 8, line_height)
    drx = dx + (@ori_contents_width + 54) / 2
    # draw_diff_value(crect, value[1], is_percent) if @comparing
    # draw_right_arrow(drx, dy)                    if @comparing
    delta = value[0] - value[1]
    delta *= -1 if InverseColorFeature.include?(info.feature_id)
    change_color(param_change_color(delta))
    draw_diff_value(nrect, value[0], is_percent)
    change_color(normal_color)
  end
  #---------------------------------------------------------------------------
end

end # if script enabled