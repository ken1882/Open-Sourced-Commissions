#=============================================================================#
#   Counter Attack+                                                           #
#   Version: 1.0.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2018.10.21                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported["COMP_CAP"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2018.10.30: Script completed                                             #
# -- 2018.10.30: Received commission and started                              #
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
#       This script will allow you to counter-attack with skill and decide    #
# the counter-attack moment.                                                  #
#                                                                             #
#   For example, place <counterskill: 4> under the enemy/actor/class/state/   #
#   or equipment's notetag field will make that battler's counter-attack to   #
#  skill which id is 4, note that overwirte priority is:                      #
#                 State > Equipment > Actor/Enemy > Class                     #
#                                                                             #
#  If battler have multiple states wherea has multiple counter-attack option, #
#  The state with higher prioity will be chosen, and chose the one with lower #
#  id if same priority.                                                       #
#                                                                             #
#  If you want to cancel the 'evasion effect' of counter-attack, just add     #
# ', eva:false' after the id like: <counterskill: 4, eva:false>               #
# This will result the battler counter-attack after taken the damage.         #
#                                                                             #
#   Most of editable option is in the module below, read the comments to know #
# what's it doing and how to adjust them for your needs.                      #
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > No extra script is required                                             #
#                                                                             #
#       ** Place this script under the matrials and above the main **         #
#                                                                             #
#   This script 99% will working if and only if in RPG Maker VX Ace. Also,    #
# this is only sutiable for the project uses default RM's battle system, if   #
# you have other battle system installed, this script won't guaranteed to     #
# work properly.                                                              #
#=============================================================================#

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  The message display when counter-attack happens
#==============================================================================
module Vocab
  CounterAttack   = "%s contrattacca con %s!"
end

#==============================================================================
# ** COMP
#------------------------------------------------------------------------------
#  Module of this script
#==============================================================================
module COMP
  module CounterAttackPlus
    #------------------------------------------------------------------------------
    # ** Module that stores regular expression
    module Regex
      #------------------------------------------------------------------------------
      # ** Regex match pattern
      CounterSkill = /<(?:counterskill):(.+)>/i
    end

    # The default counter-attack skill id
    DefaultSkillId = 1

    # The if default evasion flag not specified in notetag
    DefaultEvasion = true

    # Don't edit this unless you know what're you doing
    CounterSkill = Struct.new(:skill_id, :evasion)
    DefaultCounterSkill = CounterSkill.new(DefaultSkillId, DefaultEvasion)
  end
end
#==============================================================================
# ** DataManager
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # Alias: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_compcap load_database; end
  def self.load_database
    load_database_compcap
    load_counterskill_data
  end
  #--------------------------------------------------------------------------
  def self.load_counterskill_data
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors, $data_states]
    groups.each do |group|
      group.compact.each{|obj| obj.load_counterskill_data}
    end
  end
end
#==============================================================================
# ** RPG::BaseItem
#==============================================================================
class RPG::BaseItem
  #------------------------------------------------------------------------------
  attr_reader :counterskill
  #------------------------------------------------------------------------------
  def load_counterskill_data
    @counterskill = nil
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when COMP::CounterAttackPlus::Regex::CounterSkill
        instance_eval("parse_counterskill_data(#{$1.lstrip})")
      end
    end
  end
  #------------------------------------------------------------------------------
  def parse_counterskill_data(*args)
    sid  = args[0].to_i
    args = args[1] ? args[1] : {}
    eva  = args[:eva].nil? ? DefaultCounterSkill : args[:eva]
    @counterskill = COMP::CounterAttackPlus::CounterSkill.new(sid, eva)
  end
  #------------------------------------------------------------------------------
end
#==============================================================================
# ** Game_BattlerBase
#==============================================================================
class Game_BattlerBase
  #------------------------------------------------------------------------------
  def sorted_states
    array = states
    array.sort! do |state_a, state_b|
      if state_a.priority != state_b.priority
        state_b.priority <=> state_a.priority
      else
        state_a.id <=> state_b.id
      end
    end
    return array
  end
  #------------------------------------------------------------------------------
  def counterskill
    sorted_states.each do |obj|
      return obj.counterskill if obj.counterskill
    end
    return nil
  end
  #------------------------------------------------------------------------------
end
#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #------------------------------------------------------------------------------
  DefaultCounterSkill = COMP::CounterAttackPlus::DefaultCounterSkill
  #------------------------------------------------------------------------------
  def counterskill
    re = super
    return re if re
    (equips.compact + [actor] + [self.class]).each do |obj|
      return obj.counterskill if obj.counterskill
    end
    return DefaultCounterSkill
  end
  #------------------------------------------------------------------------------
end
#==============================================================================
# ** Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #------------------------------------------------------------------------------
  DefaultCounterSkill = COMP::CounterAttackPlus::DefaultCounterSkill
  #------------------------------------------------------------------------------
  def counterskill
    re = super
    return re if re
    re = enemy.counterskill
    return re.nil? ? DefaultCounterSkill : re
  end
  #------------------------------------------------------------------------------
end
#==============================================================================
# ** Window_BattleLog
#==============================================================================
class Window_BattleLog < Window_Selectable
  def display_counter(target, item)
    add_text(sprintf(Vocab::CounterAttack, target.name, item.name))
    wait
  end
end
#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Overwrite: Invoke Skill/Item
  #--------------------------------------------------------------------------
  def invoke_item(target, item)
    avoid_damage = true
    if rand < target.item_cnt(@subject, item)
      avoid_damage = invoke_counter_attack(target, item)
    elsif rand < target.item_mrf(@subject, item)
      invoke_magic_reflection(target, item)
    else
      apply_item_effects(apply_substitute(target, item), item)
    end
    @subject.last_target_index = target.index
  end
  #--------------------------------------------------------------------------
  # * Invoke Counterattack
  #--------------------------------------------------------------------------
  def invoke_counter_attack(target, item)
    counterskill = target.counterskill
    if counterskill.evasion
      Sound.play_evasion
    else
      apply_item_effects(apply_substitute(target, item), item)
    end
    cntitem = $data_skills[counterskill.skill_id]
    @log_window.display_counter(target, cntitem)
    item_apply_autotaget(target, @subject, cntitem)
  end
  #--------------------------------------------------------------------------
  def item_apply_autotaget(user, target, item)

    # if item scope is for all
    if item.for_all?
      if item.for_opponent?;       targets = user.opponents_unit.alive_members;
      elsif item.for_dead_friend?; targets = user.friends_unit.dead_members;
      elsif item.for_friend?;      targets = user.friends_unit.alive_members;
      end
      show_animation(targets, item.animation_id)
      targets.each do |t|
        t.item_apply(user, item)
        refresh_status
        @log_window.display_action_results(t, item)
      end

    # if item scope if for one
    else
      if item.for_opponent?; target = target;
      else; target = user;
      end
      show_animation(target, item.animation_id)
      target.item_apply(user, item)
      refresh_status
      @log_window.display_action_results(target, item)
    end
  end
  #--------------------------------------------------------------------------
end