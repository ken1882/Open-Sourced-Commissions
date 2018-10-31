#=============================================================================#
#   Counter Attack+                                                           #
#   Version: 1.1.1                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2018.10.21                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported["COMP_CAP"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2018.10.31: Add new commissioned features                                #
# -- 2018.10.30: Compatible with YEA's battle engine                          #
# -- 2018.10.30: Fix small NoMethodError                                      #
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
# > Custom Options:                                                           #
#  Available options:                                                         #
#                                                                             #
#     - eva(EVAde):                                                           #
#          true:  Evade the attack if counter-attack is occurred.             #
#          false: Counterattack after took the damage.                        #
#                                                                             # 
#     - igz(IGnoreZero):                                                      #
#          true:  No counterattack if attack not hit.                         #
#          false: Counterattack even if attack missed or evaded.              #
#         ** This option does not affected by 'eva:true' **                   #
#                                                                             #
#     - frc(FoRCed):                                                          #
#          true:  Ignore mp/tp requirement of counterskill and use without    #
#                 consime mp/tp.                                              #
#          false: Will not counter if no enough mp/tp, eva will be canceled   #
#                 if set to true.                                             #
#                                                                             #
#     - gen(GENeric attack):                                                  #
#          true:  Counter-attack to Generic attack/Certain hit.               #
#          false: No counterattack when taking Generic/Certain hit.           #
#                                                                             #
#     - phy(PHYscial):                                                        #
#          true:  Counter-attack to physical attacks.                         #
#          false: No counterattack when taking physical hit.                  #
#                                                                             #
#     - mag(MAGical):                                                         #
#          true:  Counter-attack to magical attacks.                          #
#          false: No counterattack when taking magical hit.                   #
#                                                                             #
#                                                                             #
#  If you want to change the deafault option, add:                            #
#  ', (option_name): true/false' within the '<>', for example, if you don't   #
#  want to evade the attack if counter-attack occurrs, and the counter-attack #
#  skill id be 4, the notetag should like:                                    #
#                                                                             #
#  <counterskill: 4, eva:false>                                               #
#                                                                             #
#  And another example:                                                       #
#                                                                             #
#  <counterskill: 1, eva:true, mag:true, igz:true>                            #
#   ↑                                                                         #
#  Means if counter-attack occurred, it'll evade the attack, even if it's a   #
#  magical attack, as long as the attack hit the battler.                     #
#                                                                             #
#  Contrast example:                                                          #
#                                                                             #
#  <counterskill: 123, eva: false, mag:false, igz:false>                      #
#   ↑                                                                         #
#  This is means it'll take the damage before counter-attack, except the      #
#  magical attack, and the battler will counter-attack anyway despite the     #
#  attack didn't hit it.                                                      #
#                                                                             #
#  If you didn't specified the option in notetag, it'll take the default      #
#  setting, which is adjustable below. E.X:                                   #
#                                                                             #
#   <counterskill: 1, igz:true, eva:false>                                    #
#    ↑                                                                        #
#  This is means the 'igz'(ignore zero damage) option is true and 'eva' is    #
#  false, and the others will set to default.                                 #
#                                                                             #
#  If the your default setting is unable to counter magic attack but you want #
#  to enable in some place; and the second one is able to counter all types.  #
#                                                                             #
#   <counterskill: 123, mag:true>                                             #
#   <counterskill: 123, mag:true, phy:true, gen:true>                         #
#   (chagne true to false if your default setting is true but you don't want  #
#    it able to counter somewhere)                                            #
#                                                                             #
#  Most of editable option is in the module below, read the comments to know  #
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

    # Default settings: flags when note specified in notetag
    # Whether evade incoming damage
    DefaultEvasion = true

    # Whether the counter-skill costs mp/tp, if false and battker has 
    # no enough mp/tp, the counterattack will not occurrs
    DefaultForceCounter   = false

    # Whether CNT valid to physical attacks
    DefaultCounterPhysic  = true

    # Whether CNT valid to magical attacks
    DefaultCounterMagic   = false

    # Whether CNT valid to certain hit
    DefaultCounterGeneric = false

    # Whether pass counter-attack if damage received is zero
    DefaultIgnoreZero     = true

    # Don't edit this unless you know what you're doing
    CounterSkill = Struct.new(:skill_id, :evasion, :ignore_zero, :forced, :hit_types)
    DefaultCounterSkill = CounterSkill.new(DefaultSkillId)
    DefaultCounterSkill.evasion     = DefaultEvasion
    DefaultCounterSkill.ignore_zero = DefaultIgnoreZero
    DefaultCounterSkill.forced      = DefaultForceCounter
    DefaultCounterSkill.hit_types   = [DefaultCounterGeneric, DefaultCounterPhysic, DefaultCounterMagic]

    SimpleAction = Struct.new(:user, :targets, :item, :forced)
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
        args = $1.lstrip.split(',')
        sid  = args[0].to_i
        @counterskill = COMP::CounterAttackPlus::DefaultCounterSkill.dup
        @counterskill.skill_id = sid
        args.each do |arg|
          case arg.downcase
          when /eva:(.+)/i
            str = arg.split(':').at(1)
            @counterskill.evasion = (str == 'true') ? true : false
          when /igz:(.+)/i
            str = arg.split(':').at(1)
            @counterskill.ignore_zero = (str == 'true') ? true : false
          when /frc:(.+)/i
            str = arg.split(':').at(1)
            @counterskill.forced = (str == 'true') ? true : false
          when /gen:(.+)/i
            str = arg.split(':').at(1)
            @counterskill.hit_types[0] = true  if str == 'true'
            @counterskill.hit_types[0] = false if str == 'false'
          when /phy:(.+)/i
            str = arg.split(':').at(1)
            @counterskill.hit_types[1] = true  if str == 'true'
            @counterskill.hit_types[1] = false if str == 'false'
          when /mag:(.+)/i
            str = arg.split(':').at(1)
            @counterskill.hit_types[2] = true  if str == 'true'
            @counterskill.hit_types[2] = false if str == 'false'
          end # case arg
        end # each arg
      end # case line
    end # each line
  end
  #------------------------------------------------------------------------------
end
#==============================================================================
# ** Game_BattlerBase
#==============================================================================
class Game_BattlerBase
  #------------------------------------------------------------------------------
  # * Sorted states by higher-priority and lower-id first
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
# ** Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  DefaultCounterHitTypes = COMP::CounterAttackPlus::DefaultCounterSkill.hit_types
  #--------------------------------------------------------------------------
  # * Overwrite: item_cnt >> Determine counterattack rate
  #--------------------------------------------------------------------------
  def item_cnt(user, item, hit_types = DefaultCounterHitTypes)
    return 0 unless hit_types[item.hit_type] # Attack types that cannot counter
    return 0 unless opposite?(user)          # No counterattack on allies
    return cnt                               # Return counterattack rate
  end
  #--------------------------------------------------------------------------
  # * Overwrite: item_apply
  #--------------------------------------------------------------------------
  alias item_apply_comp_cap item_apply
  def item_apply(user, item)
    # If the result has been determined
    if @result_pre_tested
      if @result.hit?
        unless item.damage.none?
          @result.critical = (rand < item_cri(user, item))
          make_damage_value(user, item)
          execute_damage(user)
        end
        item.effects.each {|effect| item_effect_apply(user, item, effect) }
        item_user_effect(user, item)
      end # if result.hit
      make_miss_popups(user, item) if $imported["YEA-BattleEngine"]
    else
      item_apply_comp_cap(user, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Pre-test whether the item hit successfully
  #--------------------------------------------------------------------------
  def test_item_hit(user, item)
    @result.clear
    @result_pre_tested = true
    @result.used = item_test(user, item)
    @result.missed = (@result.used && rand >= item_hit(user, item))
    @result.evaded = (!@result.missed && rand < item_eva(user, item))
    @result
  end
  #------------------------------------------------------------------------------
  def clear_result
    @result_pre_tested = false
    @result.clear
  end
  #--------------------------------------------------------------------------
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
    return re if re # Return result if states has counterskill
    (equips.compact + [actor] + [self.class]).each do |obj|
      return obj.counterskill if obj.counterskill
    end
    return DefaultCounterSkill # return default if no special counterskill
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
  #------------------------------------------------------------------------------
  # * Display counterattack message
  #------------------------------------------------------------------------------
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
  SimpleAction = COMP::CounterAttackPlus::SimpleAction
  #--------------------------------------------------------------------------
  # * Alias: start
  #--------------------------------------------------------------------------
  alias start_comp_cap start
  def start
    @queued_actions = []
    start_comp_cap
  end
  #--------------------------------------------------------------------------
  # * Mehtod from YEA-BattleEngine
  #------------------------------------------------------------------------------
  def invoke_item_yeabe(target, item)
    show_animation([target], item.animation_id) if separate_ani?(target, item)
    if target.dead? != item.for_dead_friend?
      @subject.last_target_index = target.index
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Alias: use_item, execute queued counter actions after attack done
  #--------------------------------------------------------------------------
  alias use_item_comp_cap use_item
  def use_item
    item = @subject.current_action.item
    use_item_comp_cap
    execute_queued_action
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Invoke Skill/Item
  #--------------------------------------------------------------------------
  def invoke_item(target, item)
    return if (@subject.dead? rescue true)
    cont = invoke_item_yeabe(target, item) if $imported["YEA-BattleEngine"]
    return unless cont

    target.test_item_hit(@subject, item)

    if counter_successful?(@subject, target, item, target.counterskill)
      invoke_counter_attack(target, item)
    elsif rand < target.item_mrf(@subject, item)
      invoke_magic_reflection(target, item)
    else
      apply_item_effects(apply_substitute(target, item), item)
    end
    target.clear_result
    @subject.last_target_index = target.index
  end
  #--------------------------------------------------------------------------
  def counter_successful?(user, target, item, counterskill)
    return false if !target.result.hit? && counterskill.ignore_zero
    return false if !counterskill.forced && !target.skill_cost_payable?($data_skills[counterskill.skill_id])
    return rand < target.item_cnt(user, item, counterskill.hit_types)
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
    apply_counterattack(target, @subject, cntitem, counterskill.forced)
  end
  #--------------------------------------------------------------------------
  def apply_counterattack(user, target, item, forced)
    
    # if item scope is for all
    if item.for_all?
      if item.for_opponent?;       targets = user.opponents_unit.alive_members;
      elsif item.for_dead_friend?; targets = user.friends_unit.dead_members;
      elsif item.for_friend?;      targets = user.friends_unit.alive_members;
      end
      register_counter_action(SimpleAction.new(user, targets, item, forced))
    # if item scope if for one
    else
      if item.for_opponent?; target = target;
      else; target = user;
      end
      register_counter_action(SimpleAction.new(user, [target], item, forced))
    end
  end
  #--------------------------------------------------------------------------
  # * Register counterattack action to queue
  #--------------------------------------------------------------------------
  def register_counter_action(action)
    @queued_actions << action
  end
  #--------------------------------------------------------------------------
  # * Executed queued counterattacks after previous attack finished
  #--------------------------------------------------------------------------
  def execute_queued_action
    @queued_actions.each do |action|
      show_animation(action.targets, action.item.animation_id)
      action.user.pay_skill_cost(action.item) unless action.forced
      action.targets.each do |t|
        next if (t.dead? rescue true)
        t.item_apply(action.user, action.item)
        refresh_status
        @log_window.display_action_results(t, action.item)
      end # each target
    end # each action
    @queued_actions.clear
  end
  #--------------------------------------------------------------------------
end