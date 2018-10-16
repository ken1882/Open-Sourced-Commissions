#=============================================================================#
#   Extended Equipment Comparsion Info                                        #
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
#       This script will change the display of original parameter comparsion  #
# in Equip Scene when changing the equipments, instead of showing default     #
# paramters, this script will only show changed parameters, including crit.   #
# evasion...etc.                                                              #
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > Require keyboard input script created By Cidiomar R. Dias Junior        #
#   > Compatible with YEA Equip Engine                                        #
#   > Support comparsion with 'Equipment Set Bonuses' by Modern Algebra       #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#=============================================================================#
# > Code compatibility details of classes and methods
#
#   - Window_EquipStatus
#       .contents_height    [overwrite]
#       .refresh            [overwrite]
#       .draw_item          [overwrite]
#       .initialize         [alias]     as: init_ecci
#       .update             [alias]     as: update_ecci
#       .update_scroll      [new]
#       .compare_diff       [new]
#=============================================================================


#------------------------------------------------------------------------------
# * Check whether Keyboard input script imported, raise inforamtion and disable
#   the script if none.
#------------------------------------------------------------------------------
COMP_EECI_Enable = true
begin
  _ = Input::KEYMAP
rescue => NameError
  info = "Keymap is not detected, please make sure you have keyboard input" +
          " script in your project and placed in right place!\n" + 
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
  # Abbr. of Extended Equipment Comparsion Information
  module EECI
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
    # * Text displayed when showing the comparsion of set equipment bonus
    SetEquipmentText = "Set bonus:"
    #---------------------------------------------------------------------
    # * Scrolling speed, aka the delta-y per frame
    Scrollspeed     = 4
    #---------------------------------------------------------------------
    # * How many lines of comparsion should be listed at most? If the
    #   differences between two equipments are more than this number, the
    #   surplus won't be displayed.
    MaxDrawLine  = 30
    #---------------------------------------------------------------------
    # * The param/feature considered to compare
    ComparsionTable = {        
      # symbol        => [id,  display text showed in comparsion]
      :feature_param  => [21, ''],                         # Parameter
      :feature_xparam => [22, ''],                         # Ex-Parameter
      :feature_sparam => [23, ''],                         # Sp-Parameter

      :special_flag   => [62, 'Special'],                  # Special feature flag
      :element_rate   => [11, 'Element Rate'],             # Element Rate
      :debuff_rate    => [12, 'Debuff Rate'],              # Debuff Rate
      :state_rate     => [13, 'State Rate'],               # State Rate
      :state_resist   => [14, 'State Resist'],             # State Resist
      :atk_element    => [31, 'Atk Element'],              # Atk Element
      :atk_state      => [32, 'Atk State'],                # Atk State
      :atk_speed      => [33, 'Atk Speed'],                # Atk Speed
      :atk_times      => [34, 'Atk Times+'],               # Atk Times+
      :stype_add      => [41, 'Add Skill Type'],           # Add Skill Type
      :stype_seal     => [42, 'Disable Skill Type'],       # Disable Skill Type
      :skill_add      => [43, 'Add Skill'],                # Add Skill
      :skill_seal     => [44, 'Disable Skill'],            # Disable Skill
      :equip_wtype    => [51, 'Equip Weapon'],             # Equip Weapon
      :equip_atype    => [52, 'Equip Armor'],              # Equip Armor
      :equip_fix      => [53, 'Lock Equip'],               # Lock Equip
      :equip_seal     => [54, 'Seal Equip'],               # Seal Equip
      :slot_type      => [55, 'Slot Type'],                # Slot Type
      :action_plus    => [61, 'Action Times+'],            # Action Times+
      :party_ability  => [64, 'Party ability'],            # Party ability
      # --- Special Feature Flags ---
      :flag_id_auto_battle    => [0, 'auto battle'],       # auto battle
      :flag_id_guard          => [1, 'guard'],             # guard
      :flag_id_substitute     => [2, 'substitute'],        # substitute
      :flag_id_preserve_tp    => [3, 'preserve TP'],       # preserve TP
    }
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
    # * prefix of single feature comparsion
    FeatureAddText     = "+ %s"
    FeatureRemoveText  = "- %s"
    FeatureEnableText  = "O %s"
    FeatureDisableText = "X %s"
    #=====================================================================#
    # Please don't edit anything below unless you know what you're doing! #
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
    IterableFeatureID = {
      21  => :param,
      22  => :xparam,
      23  => :sparam,
      11  => :element,
      31  => :element,
      13  => :state,
      14  => :state,
      12  => :debuff,
      41  => :stype,
      42  => :stype,
      43  => :skills,
      44  => :skills,
      51  => :wtype,
      52  => :atype,
      53  => :etype,
      54  => :etype,
      55  => :slot_type,
      64  => :party_ability,
    }

    # Strcuture holds compare result of each difference
    DiffInfo = Struct.new(:feature_id, :data_id, :delta, :display_str)
    # :feature_id > what do you expect me to say?
    # :data_id    > data id in grouped feature, such as param
    # :delta      > value changed of that feature, in certain feature id is:
    #   true/false  = add/remove after equip
    # :display_str > Other text displayed
  end
end

#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
end

#==============================================================================
# ** Window_EquipStatus
#------------------------------------------------------------------------------
#  This window displays actor parameter changes on the equipment screen.
#==============================================================================
class Window_EquipStatus < Window_Base
  include COMP::EECI
  EQS_Enable = $imported[:MA_EquipmentSetBonuses]
  #---------------------------------------------------------------------------
  # * Instance variables
  #---------------------------------------------------------------------------
  attr_reader :difference
  attr_reader :set_difference if EQS_Enable
  #---------------------------------------------------------------------------
  # * Alias method: initialize
  #---------------------------------------------------------------------------
  alias init_eeci initialize
  def initialize(*args)
    @bottom_oy      = 0
    @difference     = {}
    init_eeci(*args)
    @visible_height = height - standard_padding * 2
  end
  #---------------------------------------------------------------------------
  # * Overwrite methods: contents height
  #   Allocate max possible height at first to prevent the lag of dynamic
  #   allocate contents
  #---------------------------------------------------------------------------
  def contents_height
    (MaxDrawLine + 1) * line_height
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
      by = @bottom_oy + 4
      self.oy = [self.oy + delta, by].min if self.oy < by
    end
  end
  #---------------------------------------------------------------------------
  # * Overwrite method: refresh
  #---------------------------------------------------------------------------
  def refresh        
    contents.clear
    self.oy    = 0
    @button_oy = 0
    self.arrows_visible = false
    @difference.clear
    return unless @temp_actor && @actor
    compare_diffs
    @button_oy = ([@difference.values.flatten.size, MaxDrawLine].min) * line_height
    self.arrows_visible = @button_oy > @visible_height
    draw_comapre_result
  end
  #---------------------------------------------------------------------------
  def compare_diffs
    ComparsionTable.each do |symbol, info|
      feature_id  = info[0]
      display_str = info[1]
      if IterableFeatureID.keys.include?(feature_id)
        case feature_id
        when 21; compare_param_diff(feature_id);
        when 22; compare_param_diff(feature_id);
        when 23; compare_param_diff(feature_id);
        when 43; compare_skill_change_diff(feature_id)
        when 44; compare_skill_change_diff(feature_id)
        when 11; compare_element_rate_diff(feature_id)
        when 31; compare_ATKelement_diff(feature_id)
        end
      else
      end
    end # ComparsionTable.each
  end
  #---------------------------------------------------------------------------
  def compare_param_diff(feature_id)
    fid = feature_id
    len = {21 => 8, 22 => 10, 23 => 10}
    method = IterableFeatureID[fid]
    ar = len[fid].times.collect{|i| (@temp_actor.send(method, i)) - @actor.send(method, i)}

    ar.each_with_index do |delta, i|
      next if delta == 0
      delta = delta.round(2) if delta.is_a?(Float)
      case fid
      when 21; str = Vocab.param(i);
      when 22; str = XParamName[i];
      when 23; str = SParamName[i];
      end
      (@difference[feature_id] ||= []) << DiffInfo.new(feature_id, i, delta, str || '')
    end
  end
  #---------------------------------------------------------------------------
  def compare_skill_change_diff(feature_id)
    if feature_id == 43
      before = @temp_actor.added_skills
      after  = @actor.added_skills
    elsif feature_id == 44
      before = @temp_actor.features_set(feature_id)
      after  = @actor.features_set(feature_id)
    end

    prefix = (feature_id == 43) ? FeatureAddText : FeatureDisableText;
    after.select{|sid| !before.include?(sid)}.each do |sid|
      str = sprintf(prefix, $data_skills[sid].name)
      (@difference[feature_id] ||= []) << DiffInfo.new(feature_id, sid,  true, str)
    end

    prefix = (feature_id == 43) ? FeatureRemoveText : FeatureEnableText;
    before.select{|sid| !after.include?(sid)}.each do |sid|
      str = sprintf(prefix, $data_skills[sid].name)
      (@difference[feature_id] ||= []) << DiffInfo.new(feature_id, sid, false, str)
    end
  end
  #---------------------------------------------------------------------------
  def compare_element_rate_diff(feature_id)
    len = $data_system.elements.size + 1
    len.times do |i|
      delta = @temp_actor.features_pi(feature_id, i) - @actor.features_pi(feature_id, i)
      next if delta == 0
      str = $data_system.elements[i]
      (@difference[feature_id] ||= []) << DiffInfo.new(feature_id, i, delta, str)
    end
  end
  #---------------------------------------------------------------------------
  def compare_ATKelement_diff(feature_id)
    before = @actor.atk_elements
    after  = @temp_actor.atk_elements

    after.select{|id| !before.include?(id)}.each do |id|
      str = sprintf(FeatureAddText, $data_system.elements[id])
      (@difference[feature_id] ||= []) << DiffInfo.new(feature_id, id,  true, str)
    end

    before.select{|id| !after.include?(id)}.each do |id|
      str = sprintf(FeatureRemoveText, $data_system.elements[id])
      (@difference[feature_id] ||= []) << DiffInfo.new(feature_id, id, false, str)
    end
  end
  #---------------------------------------------------------------------------
  def draw_comapre_result
    counter = 0
    @difference.each do |k, dar|
      puts "#{k} #{dar}"
      dar.each do |info|
        dy = counter * line_height
        break if dy > @button_oy + 1
        draw_item(0, dy, info)
        counter += 1
      end
    end
  end
#---#
  #---------------------------------------------------------------------------
if $imported["YEA-AceEquipEngine"]
  def draw_item(dx, dy, info)
    self.contents.font.size = YEA::EQUIP::STATUS_FONT_SIZE
    
    reset_font_settings
  end
else
  def draw_item(dx, dy, infp)  
  end
end
#---#
  #---------------------------------------------------------------------------
end # class Window_EQ status
end # enable
