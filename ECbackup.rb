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
# -- 2018.10.21: First release                                                #
#                                                                             #
#=============================================================================#
#                       ** End-User License Agreement **                      #
#-----------------------------------------------------------------------------#
#  1. Copyright and Redistribution:                                           #
#       All codes were written by me(Compeador), and you(the user) may edit   #
#  the code for your own need without permission (duh).                       #
#  Redistribute this script must agreed by VaiJack8, who commissioned this    #
#  script, and you must share the original version released by the author     #
#  without edits.                                                             #
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
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > Require keyboard input script created By Cidiomar R. Dias Junior        #
#   > Compatible with YEA Equip Engine                                        #
#   > Support comparison with 'Equipment Set Bonuses' by Modern Algebra       #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#=============================================================================#
# > Code compatibility details of classes and methods
#
#   - Window_EquipStatus
#       .contents_height    [overwrite]
#       .refresh            [overwrite]
#       .draw_item          [overwrite]
#       .initialize         [alias]     as: init_eeci
#       .update             [alias]     as: update_eeci
#=============================================================================

# Enable this script?
COMP_EECI_Enable = true
#------------------------------------------------------------------------------
# * Check whether Keyboard input script imported, raise inforamtion and disable
#   the script if none.
#------------------------------------------------------------------------------
begin
  _ = Input::KEYMAP
rescue => NameError
  info = "Keymap is not detected, please make sure you have keyboard input" +
          " script in your project and placed above this script!\n\n" + 
          "The EECI script will be disabled."
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
    
    #=====================================================================
    # * The scroll-up and scroll-down keybind, edit the value for your own
    # need. For example, if you want 'I' and 'K' for scroll up/down,
    # edit the 
    # 'Input::KEYMAP[:LETTER_R]' to 'Input::KEYMAP[:LETTER_I]' and
    # 'Input::KEYMAP[:LETTER_F]' to 'Input::KEYMAP[:LETTER_K]'.
    # Take a look at the keyboard script for all supported key and symbol
    #=====================================================================
    Key_scrollup    = Input::KEYMAP[:LETTER_R]
    Key_scrolldown  = Input::KEYMAP[:LETTER_F]
    #---------------------------------------------------------------------
    # * Text displayed when showing the comparison of set equipment bonus
    SetEquipmentText = "Set bonus:"
    #---------------------------------------------------------------------
    # * Scrolling speed, aka the delta-y per frame
    Scrollspeed     = 4
    #---------------------------------------------------------------------
    # * How many lines of comparison should be listed at most? If the
    #   differences between two equipments are more than this number, the
    #   surplus won't be displayed to prevent the lag.
    MaxDrawLine  = 30
    #---------------------------------------------------------------------
    # * The param/feature considered to compare
    ComparisonTable = {        
      # symbol        => [id,  display group text showed in comparison]
      :param       => [-1, ''],                                     # Basic parameter
      :xparam      => [FEATURE_XPARAM, ''],                         # Ex-Parameter
      :sparam      => [FEATURE_SPARAM, ''],                         # Sp-Parameter

      :param_rate     => [FEATURE_PARAM, 'Param multipler'],        # Parameter
      :special_flag   => [FEATURE_SPECIAL_FLAG, 'Special'],         # Special feature flag
      :element_rate   => [FEATURE_ELEMENT_RATE, 'Element Rate'],    # Element Rate
      :debuff_rate    => [FEATURE_DEBUFF_RATE, 'Debuff Rate'],      # Debuff Rate
      :state_rate     => [FEATURE_STATE_RATE, 'State Rate'],        # State Rate
      :state_resist   => [FEATURE_STATE_RESIST, 'State Resist'],    # State Resist
      :atk_element    => [FEATURE_ATK_ELEMENT, 'Atk Element'],      # Atk Element
      :atk_state      => [FEATURE_ATK_STATE, 'Atk State'],          # Atk State
      :atk_speed      => [FEATURE_ATK_SPEED, 'Feature'],          # Atk Speed
      :atk_times      => [FEATURE_ATK_TIMES, 'Feature'],         # Atk Times+
      :stype_add      => [FEATURE_STYPE_ADD, 'Add Skill Type'],     # Add Skill Type
      :stype_seal     => [FEATURE_STYPE_SEAL, 'Disable Skill Type'],# Disable Skill Type
      :skill_add      => [FEATURE_SKILL_ADD, 'Add Skill'],          # Add Skill
      :skill_seal     => [FEATURE_SKILL_SEAL, 'Disable Skill'],     # Disable Skill
      :equip_wtype    => [FEATURE_EQUIP_WTYPE, 'Equip Weapon'],     # Equip Weapon
      :equip_atype    => [FEATURE_EQUIP_ATYPE, 'Equip Armor'],      # Equip Armor
      :equip_fix      => [FEATURE_EQUIP_FIX, 'Lock Equip'],         # Lock Equip
      :equip_seal     => [FEATURE_EQUIP_SEAL, 'Seal Equip'],        # Seal Equip
      :slot_type      => [FEATURE_SLOT_TYPE, 'Slot Type'],          # Slot Type
      :action_plus    => [FEATURE_ACTION_PLUS, 'Action Times+'],    # Action Times+
      :party_ability  => [FEATURE_PARTY_ABILITY, 'Party ability'],  # Party ability
    }
    #---------------------------------------------------------------------
    # * Compare with MA's equipment set diff
    if $imported[:MA_EquipmentSetBonuses]
      FeatureEquipSet = -2
      ComparisonTable[:equipset_plus] = [FeatureEquipSet, 'Equipment Set Bonus']   
    end
    #---------------------------------------------------------------------
    # * Display order of comparison group text, upper one displayed first
    MISC_text = 'Other' # the group text not in this order list
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
      'Equipment Set Bonus',
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
      FEATURE_ATK_SPEED   => 'ASP',
      FEATURE_ATK_TIMES   => 'ATS+',
      FEATURE_ACTION_PLUS => '+%d:',
    }
    #---------------------------------------------------------------------
    # * prefix of single feature comparison
    FeatureAddText     = "+ %s"
    FeatureRemoveText  = "- %s"
    FeatureEnableText  = "√ %s"
    FeatureDisableText = "X %s"
    #---------------------------------------------------------------------
    InverseColorFeature = [FEATURE_STYPE_SEAL, FEATURE_SKILL_SEAL]
    PercentageFeaure = [
      FEATURE_ELEMENT_RATE, FEATURE_DEBUFF_RATE, FEATURE_STATE_RATE,
      FEATURE_PARAM, FEATURE_XPARAM, FEATURE_SPARAM, FEATURE_ATK_STATE,
      FEATURE_ACTION_PLUS, 
    ]
    #=====================================================================#
    # Please don't edit anything below unless you know what you're doing! #
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#

    # Strcuture holds compare result of each difference
    DiffInfo = Struct.new(:feature_id, :data_id, :value, :display_str)
    # :feature_id > what do you expect me to say?
    # :data_id    > data id in grouped feature, such as param
    # :delta      > value changed of that feature, in certain feature id is:
    #   true/false  = add/remove after equip
    # :display_str > Other text displayed

    CurFeatureShow = [-1]

    #--------------------------------------------------------------------------
    # * Mapping table for easier query
    StringTable  = {}   # feature_id   => display_text
    FeatureIdTable = {} # display_text => feature_id
    DisplayOrder = {}   # display_text => order
    DisplayIdOrder = {} # feature_id   => order
    ComparisonTable.each do |symbol, info|
      StringTable[info[0]] = info[1]
      FeatureIdTable[info[1]] = info[0]
    end
    TextDisplayOrder.each_with_index do |str, i|
      DisplayOrder[str] = i
      DisplayIdOrder[FeatureIdTable[str]] = i
    end
    #--------------------------------------------------------------------------
    # * Dummy equipment for optimaztion
    Dummy = RPG::Weapon.new
  end
end
puts "#{COMP::EECI::DisplayIdOrder}"
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
# ** Scene_Equip
#==============================================================================
class Scene_Equip < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * alias: slot [OK]
  #--------------------------------------------------------------------------
  alias on_slot_ok_eeci on_slot_ok
  def on_slot_ok
    @status_window.set_template_item(@actor.equips.at(@slot_window.index))
    on_slot_ok_eeci
  end
  #--------------------------------------------------------------------------
  # alias: create_status_window
  #--------------------------------------------------------------------------
  alias create_status_window_eeci create_status_window
  def create_status_window
    create_status_window_eeci
    @status_window.collect_current_feature
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
  attr_reader :difference, :equipset_diff
  attr_reader :set_difference if EQS_Enable
  #---------------------------------------------------------------------------
  # * Alias method: initialize
  #---------------------------------------------------------------------------
  alias init_eeci initialize
  def initialize(*args)
    @bottom_oy      = 1
    @difference     = {}
    @equipset_diff  = {}
    @feature_cache  = {}
    @base_actor     = nil
    init_eeci(*args)
    @visible_height = height
  end
  #---------------------------------------------------------------------------
  # * Dummy method, does nothing
  #---------------------------------------------------------------------------
  def pass(*args)
  end
  #---------------------------------------------------------------------------
  # * Overwrite methods: contents height
  #---------------------------------------------------------------------------
  def contents_height
    @bottom_oy
  end
  #---------------------------------------------------------------------------
  # * Alias method: update
  #---------------------------------------------------------------------------
  alias update_eeci update
  def update
    update_eeci
    update_scroll
  end
  #---------------------------------------------------------------------------
  # * New method: update scroll
  #---------------------------------------------------------------------------
  def update_scroll
    return unless self.arrows_visible
    delta = Scrollspeed
    delta *= 3 if Input.press?(Input::SHIFT)
    if Input.trigger?(Key_scrollup) || Input.press?(Key_scrollup)
      self.oy = [self.oy - delta, 0].max if self.oy > 0
    elsif Input.trigger?(Key_scrolldown) || Input.press?(Key_scrolldown)
      by = [@bottom_oy - @visible_height + standard_padding * 3, 0].max
      self.oy = [self.oy + delta, by].min if self.oy < by
    end
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
    self.oy    = 0
    @bottom_oy = 1
    self.arrows_visible = false
    @difference.clear
    
    return unless @actor
    if @temp_actor && @compare_item && @template_item
      compare_diffs
      list = @difference
      p 'refresh 1'
    else
      list = @current_feature
      p 'refresh 2'
    end
    return if list.nil?
    line_number  = list.keys.count{|k| (list[k] || []).size > 0 && StringTable[k].length > 0}
    line_number += list.values.flatten.size
    @bottom_oy   = ([line_number, MaxDrawLine].min) * line_height
    create_contents
    self.arrows_visible = @bottom_oy > @visible_height
    draw_compare_result(list == @current_feature)
  end
  #---------------------------------------------------------------------------
  def collect_current_feature
    return unless @actor
    p 'cuf'
    @current_feature = {}
    compare_diffs(:current)
  end
  #---------------------------------------------------------------------------
  def compare_diffs(stage = :diff)
    en_prefix   = [FeatureDisableText, FeatureEnableText]
    ComparisonTable.each do |symbol, info|
      feature_id  = info[0]
      display_str = info[1]
      case symbol
      when :param;        compare_param(stage);
      when :param_rate;   compare_valued_feature(stage,feature_id, true)
      when :xparam;       compare_features_sum(stage,feature_id);
      when :sparam;       compare_features_pi(stage,feature_id);
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
      collect_equipment_set_diff if stage != :eqset && feature_id == FeatureEquipSet
    end # ComparisonTable.each

  end
  #---------------------------------------------------------------------------
  def get_cache_feature(id, method, *args, &block)
    return @feature_cache[id] if @feature_cache[id]
    return (@feature_cache[id] = @base_actor.send(method, *args, &block))
  end
  #---------------------------------------------------------------------------
  def hash_feature_idx(feature_id, index = 0)
    return index * 10000 + feature_id
  end
  #---------------------------------------------------------------------------
  def compare_param(stage,feature_id = FEATURE_PARAM)
    ar = get_feature_array(feature_id)
    len = ar.size
    feature_id = -1
    len.times do |i|
      str = get_feature_name(feature_id, i)
      # Show current actor feature status
      if stage == :current
        v = @actor.param(i)
        (@current_feature[feature_id] ||= []) << DiffInfo.new(feature_id,i,[v,v],str)
        next
      # Comparison
      else
        a = @compare_item.param(i)
        b = @template_item.param(i)
        next if a - b == 0
        a += get_cache_feature(i, :param, i)
        b += get_cache_feature(i, :param, i)
        inf = DiffInfo.new(feature_id, i, [a,b], str)
        
        if stage == :diff
          (@difference[feature_id] ||= []) << inf
        elsif stage == :eqset
          (@equipset_diff[feature_id] ||= []) << inf
        end
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
        (@current_feature[feature_id] ||= []) << DiffInfo.new(feature_id,0,[v,v],str)
        return
      else
        # Comparison
        a = @compare_item.features_sum_all(feature_id)
        b = @template_item.features_sum_all(feature_id)
        delta = (a - b)
        delta = delta.round(2) if delta.is_a?(Float)
        return if delta == 0
        a += get_cache_feature(feature_id, :features_sum_all, feature_id)
        b += get_cache_feature(feature_id, :features_sum_all, feature_id)
        inf = DiffInfo.new(feature_id, 0, [a,b], str)
        if stage == :diff
          (@difference[feature_id] ||= []) << inf
        elsif stage == :eqset
          (@equipset_diff[feature_id] ||= []) << inf
        end
      end
    else
      len.times do |i|
        str = get_feature_name(feature_id, i)
        # Show current actor feature status
        if stage == :current
          return unless CurFeatureShow.include?(feature_id)
          v = @actor.features_sum(feature_id, i)
          next if v == 0
          (@current_feature[feature_id] ||= []) << DiffInfo.new(feature_id,i,[v,v],str)
          next
        else
          # Comparison
          a = @compare_item.features_sum(feature_id, i)
          b = @template_item.features_sum(feature_id, i)
          delta = (a - b)
          delta = delta.round(2) if delta.is_a?(Float)
          next if delta == 0
          a += get_cache_feature(hash_feature_idx(feature_id, i), :features_sum, feature_id, i)
          b += get_cache_feature(hash_feature_idx(feature_id, i), :features_sum, feature_id, i)
          inf = DiffInfo.new(feature_id, i, [a,b], str)
          if stage == :diff
            (@difference[feature_id] ||= []) << inf
          elsif stage == :eqset
            (@equipset_diff[feature_id] ||= []) << inf
          end
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
        (@current_feature[feature_id] ||= []) << DiffInfo.new(feature_id,i,[v,v],str)
        next
      else
        # Comparison
        a = @compare_item.features_pi(feature_id, i)
        b = @template_item.features_pi(feature_id, i)
        delta = (a - b)
        delta = delta.round(2) if delta.is_a?(Float)
        next if delta == 0
        a *= get_cache_feature(hash_feature_idx(feature_id, i), :features_pi, feature_id, i)
        b *= get_cache_feature(hash_feature_idx(feature_id, i), :features_pi, feature_id, i)
        inf = DiffInfo.new(feature_id, i, [a,b], str)
        if stage == :diff
          (@difference[feature_id] ||= []) << inf
        elsif stage == :eqset
          (@equipset_diff[feature_id] ||= []) << inf
        end
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
        (@current_feature[feature_id] ||= []) << DiffInfo.new(feature_id,i,true,str)
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

      diffs.each do |diff|
        if stage == :diff
          (@difference[feature_id] ||= []) << diff
        elsif stage == :eqset
          (@equipset_diff[feature_id] ||= []) << diff
        end
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
        (@current_feature[feature_id] ||= []) << DiffInfo.new(feature_id,i,[v,v],str)
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
        a += get_cache_feature(hash_feature_idx(feature_id, id), method_symbol, feature_id, id)
        b += get_cache_feature(hash_feature_idx(feature_id, id), method_symbol, feature_id, id)
        str = get_feature_name(feature_id, id)
        inf = DiffInfo.new(feature_id, id, [a,b], str)
        if stage == :diff
          (@difference[feature_id] ||= []) << inf
        elsif stage == :eqset
          (@equipset_diff[feature_id] ||= []) << inf
        end
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
        str = sprintf(get_feature_name(feature_id), i)
        (@current_feature[feature_id] ||= []) << DiffInfo.new(feature_id,i,[v,v],str)
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
        str = sprintf(get_feature_name(feature_id), i)
        inf = DiffInfo.new(feature_id, 0, [a,b], str)
        if stage == :diff
          (@difference[feature_id] ||= []) << inf
        elsif stage == :eqset
          (@equipset_diff[feature_id] ||= []) << inf
        end
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
        (@current_feature[feature_id] ||= []) << DiffInfo.new(feature_id,i,true,str)
        next
      else
        # Comparison
        before = @template_item.special_flag(i)
        after  = @compare_item.special_flag(i)
        next if before == after
        enabled = after ? 1 : 0
        str = sprintf(prefix[enabled], str)
        inf = DiffInfo.new(feature_id, i, after, str)
        if stage == :diff
          (@difference[feature_id] ||= []) << inf
        elsif stage == :eqset
          (@equipset_diff[feature_id] ||= []) << inf
        end
      end
    end
  end
  #---------------------------------------------------------------------------
  def compare_party_ability(stage,feature_id, prefix = [FeatureRemoveText, FeatureAddText])
    ar = PartyAbilityName
    ar.each do |i, str|
      # Show current actor feature status
      if stage
        return unless CurFeatureShow.include?(feature_id)
        en = @actor.party_ability(i)
        next unless en
        str = sprintf(prefix[1], str)
        (@current_feature[feature_id] ||= []) << DiffInfo.new(feature_id,i,true,str)
        next
      else
        # Comparison
        before = @template_item.party_ability(i)
        after  = @compare_item.party_ability(i)
        next if before == after
        enabled = after ? 1 : 0
        str = sprintf(prefix[enabled], str)
        inf = DiffInfo.new(feature_id, i, after, str)
        if stage == :diff
          (@difference[feature_id] ||= []) << inf
        elsif stage == :eqset
          (@equipset_diff[feature_id] ||= []) << inf
        end
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
  def get_feature_name(feature_id, index = nil)
    case feature_id
    when FEATURE_ATK_ELEMENT;   return $data_system.elements[index];
    when FEATURE_ELEMENT_RATE;  return $data_system.elements[index];
    when FEATURE_PARAM;         return Vocab.param(index);
    when FEATURE_XPARAM;        return XParamName[index];
    when FEATURE_SPARAM;        return SParamName[index];
    when FEATURE_SKILL_ADD;     return $data_skills[index].name;
    when FEATURE_SKILL_SEAL;    return $data_skills[index].name;
    when FEATURE_STATE_RATE;    return $data_states[index].name;
    when FEATURE_STATE_RESIST;  return $data_states[index].name;
    when FEATURE_ATK_STATE;     return $data_states[index].name;
    when FEATURE_EQUIP_WTYPE;   return $data_system.weapon_types[index];
    when FEATURE_EQUIP_ATYPE;   return $data_system.armor_types[index];
    when FEATURE_STYPE_ADD;     return $data_system.skill_types[index];
    when FEATURE_STYPE_SEAL;    return $data_system.skill_types[index];
    when FEATURE_PARTY_ABILITY; return PartyAbilityName[index];
    when FEATURE_SPECIAL_FLAG;  return SpecialFeatureName[index];
    when FEATURE_EQUIP_FIX;     return slot_name(index);
    when FEATURE_EQUIP_SEAL;    return slot_name(index);
    else
      return OtherFeatureName[feature_id] || ""
    end
  end
  #---------------------------------------------------------------------------
  def get_feature_array(feature_id)
    case feature_id
    when FEATURE_ATK_ELEMENT;   return $data_system.elements;
    when FEATURE_ELEMENT_RATE;  return $data_system.elements;
    when FEATURE_PARAM;         return Array.new($data_system.terms.params.size, 0);
    when FEATURE_XPARAM;        return Array.new(XParamName.size, 0);
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
    draw_compare_result(true)
  end
  #---------------------------------------------------------------------------
  def draw_compare_result(cur_feat = false)
    counter = 0
    list = cur_feat ? @current_feature : @difference
    diff = list.sort_by{|k, dar|
      DisplayOrder[StringTable[dar.first.feature_id]] ? DisplayOrder[StringTable[dar.first.feature_id]] : DisplayOrder[MISC_text]
    }.collect{|p| p[1]}
    last_display_group = ''
    diff.each do |infos|
      feature_id = infos.first.feature_id
      group_text = StringTable[feature_id]
      if last_display_group != group_text && group_text.length > 0
        last_display_group = group_text
        rect = Rect.new(0, counter * line_height, contents_width, line_height)
        draw_text(rect, group_text)
        counter += 1
      end
      infos.each do |info|
        dy = counter * line_height
        break if dy > @bottom_oy + 1
        draw_item(0, dy, info)
        counter += 1
      end
    end
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
        info.value ^= true;
        draw_skill_change(dx + 8, dy, info)
      else
        draw_info_change(dx + 8, dy, info.display_str)
      end
      change_color(normal_color)
    else
      draw_info_name(dx + 4, dy, info.display_str)
      draw_info_diff(dx + 8, dy, info.value, PercentageFeaure.include?(info.feature_id))
    end
    reset_font_settings if $imported["YEA-AceEquipEngine"]
  end
  #---------------------------------------------------------------------------
  def draw_info_change(dx, dy, str)
    rect = Rect.new(0, dy, contents.width-4, line_height)
    draw_text(rect, str, 2)
  end
  #---------------------------------------------------------------------------
  def draw_skill_change(dx, dy, info)
    str = info.display_str
    return draw_info_change(dx, dy, str) unless (info.data_id || 0) > 0
    text_width = self.contents.text_size(str).width
    dx = contents.width - text_width - 34
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
    draw_text(dx, dy, contents.width, line_height, str)
    change_color(normal_color)
  end
  #---------------------------------------------------------------------------
  def draw_info_diff(dx, dy, value, is_percent = false)
    dw = (contents.width + 22) / 2
    crect = Rect.new(0, dy, dw, line_height)
    nrect = Rect.new(0, dy, contents.width-4, line_height)
    drx = (contents.width + 22) / 2
    draw_diff_value(crect, value[1], is_percent)
    draw_right_arrow(drx, dy)
    change_color(param_change_color(value[0] - value[1]))
    draw_diff_value(nrect, value[0], is_percent)
    change_color(normal_color)
  end
  #---------------------------------------------------------------------------
  def draw_diff_value(rect, value, is_percent)
    str = value.to_s
    str = sprintf("%s\%", (value * 100).to_i) if is_percent
    draw_text(rect, str, 2)
  end
#-#
  #---------------------------------------------------------------------------
  # * Compare the equipment set bonus, written by Modern Algebra
  #---------------------------------------------------------------------------
if $imported[:MA_EquipmentSetBonuses]
  #---------------------------------------------------------------------------
  def collect_equipment_set_diff
    return unless @actor && @temp_actor
    before = @actor.maesb_sets || []
    after  = @temp_actor.maesb_sets || []
    return if before.size + after.size == 0
    feature_id = FeatureEquipSet

    btmp_item = @temp_item    ? @temp_item.dup : nil
    bcmp_item = @compare_item ? @compare_item.dup : nil

    after.select{|obj| !before.include?(obj)}.each do |obj|
      @temp_item = Dummy
      @compare_item = obj
      compare_diff(:equipset)
    end

    before.select{|obj| !after.include?(obj)}.each do |obj|
      @temp_item = obj
      @compare_item = Dummy
      compare_diff(:equipset)
    end
    
  end
end
  #---------------------------------------------------------------------------
#-#
end # class Window_EQ status
end # enable

=begin
  # backup method of another version of 'def compare_diff'
    ComparisonTable.each do |symbol, info|
      feature_id  = info[0]
      display_str = info[1]
      method_symbol = :pass # do nothing
      args          = []
      case symbol
      when :atk_speed;    method_symbol = :compare_features_sum;
      when :atk_times;    method_symbol = :compare_features_sum;
      when :action_plus;  method_symbol = :compare_action_plus;
      when :special_flag; method_symbol = :compare_special_flag;
      when :party_ability;method_symbol = :compare_party_ability;
      when :xparam;       method_symbol = :compare_features_sum;
      when :sparam;       method_symbol = :compare_features_pi;
      when :skill_add;    method_symbol = :compare_features_set;
      when :skill_seal;   method_symbol = :compare_features_set;
      when :element_rate; method_symbol = :compare_features_pi;
      when :atk_element;  method_symbol = :compare_features_set;
      when :state_resist;  method_symbol = :compare_features_set;
      when :param
        method_symbol = :compare_param
        feature_id    = -1
      when :param_rate
        method_symbol = :compare_valued_feature
        args = [true]
      when :atk_state
        method_symbol = :compare_valued_feature
        args = [false]
      when :state_rate
        method_symbol = :compare_valued_feature
        args = [true]
      when :stype_seal
        method_symbol = :compare_features_set;
        args = [en_prefix.reverse]
      when :stype_add
        method_symbol = :compare_features_set;
        args = [en_prefix]
      when :equip_fix
        method_symbol = :compare_features_set
        args = [en_prefix.reverse]
      end
      self.method(method_symbol).call(stage, feature_id, *args)
    end # ComparisonTable.each
=end