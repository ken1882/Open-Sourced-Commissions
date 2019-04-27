

$imported = {} if $imported.nil?
$imported["RDeus - Hime Skill Links Plugin"] = true
puts("#{$imported.size}~ (+)RDeus - Hime Skill Links - Plugin") if $TEST

=begin
***verified***
==============================================================================
  Hime's Skill Links Plugin
  RogueDeus - Conditional Links v1.0.3
  Released: 2014.05.07

  -- v1.0 :: 2014.05.06
    + Initial Version.

  -- v1.0.1 :: 2014.05.13
    + Fixed potential target array size issue.
    + Added 'unique' target variable collection.

  -- v1.0.2 :: 2015.07.30
    + made compatible with Hime - Skill Links Update (Feb 15, 2015)

  -- v1.0.3 :: 2015.07.31
    + Added FREE links option to conditionals.

    

==============================================================================
DESCRIPTION:
==============================================================================
  This plugin adds a new note tag for skill links, that allows for simple % 
  chance, as well as complex formula evaluation, conditions. There are few if
  any limitations on what your formula can contain so long as it resolves 
  true/false. 

==============================================================================
CREDIT:
==============================================================================

  Tsukihime - Skill Links
    http://www.himeworks.com/2014/03/30/skill-links/

==============================================================================
TERMS OF USE:
==============================================================================
  See: Tsukihime - Skill Links

==============================================================================

  ** Installation
    Place directly underneath Hime's Skill Links
      Requires:
        Tsukihime - Skill Links

#===============================================================================

  ** Usage 
    ALL NOTE TAGS ARE REPLACEMENTS FOR HIME'S NOTE TAGS. 
    However, you can use both if you wish. 
    If they are used together, they will STACK. 

    All note tags are processed individually, in order.
    Tag conditions that reference another tags success will need to be placed
    UNDER such references. (See: Example 7)

  NOTE TAG:
    <link_skill_cond>
    id: X
    chance: Y
    condition: Z
    <free_link>
    </link_skill_cond>

      X:  (skill/item ID) 

      Y:  (1.0 = 100%)

      Z:  (formula must eval true/false)
        Primary Condition Formula Variable References:
        a = actor using the item
        l = last conditionally linked item (for conditional, conditional links!)
        r = results_stats (combo of all linked results)

        p = $game_party (Ex: p.highest_level > 10)
        t = $game_troop (Ex: t.turn_count > 1)
        v = $game_variables (Ex: v[100] >= 3)
        s = $game_switches (Ex: s[100] == true)

      <free_link>
        This note tag must be used as shown. If present in the conditional,
        the linked action will not consume an item, or skill cost when linked.
        Note: This only works with my note tags. Not Hime's default note tags.

    Base Example:
      This example will fire off skill(2) 100% of the time, but only if nothing
      died as a result of the linking skills use. If the linking skill was a 
      single target scope, then the original target must still be alive for
      skill(2) to be performed. If the linking skill was a multi-target scope
      then neither of its targets can have died. See Detailed Descriptions 
      below for more accurate measures.

    <link_skill_cond>
    id: 2 
    chance: 1
    condition: r.is_alive
    </link_skill_cond>

    #---------------------------------------------------------------------------
    RESULTS STATS: 
      This is a collection of the total effect on all targets, 
      accomplished by the last item/skill used in battle
      by the current actor. 

      Important!!! This information is cleared upon the execution of
        the next successful item/skill link. Keep that in mind when
        creating conditional trees. You will only be able to reference
        the most previous of all the successful links.

          >>> Failed links are not tracked at all. <<<

                  EXTENDED EXAMPLE FORMULA REFERENCES
          ***********************************************************
          ****    Remember all Array indexes start at 0 not 1    ****
          ***********************************************************
          r.results[x]         # (in order) Array of all linked results
            r.results[x].hit?  # Returns if target did not miss or evade
          r.targets[x]         # (in order) Array of all battlers targeted
            r.targets[x].dead? # Returns if the target died in the attack
          r.killed[x]          # (in order) Array of battlers killed 
            r.killed[x].size   # Returns the number of targets killed
          ***********************************************************
          r.u_targets[x]       # (in order) Array of unique targets
          ***********************************************************
          r.all_dead           # Did all targets die?
          r.is_alive           # False if ANY target dies. (!r.is_alive = true) 
          r.last               # Last battler targeted
          ***********************************************************
          r.count              # Total uses (for comparison of below)
            r.misses           # Num of uses that did-not hit
            r.evades           # Num of uses that were evaded
            r.hits             # Num of uses that weren't evaded or missed
            r.successes        # Num of *hits that dealt damage
            r.crits            # Num of *hits that crit
          ***********************************************************
            r.u_evades         # Num of uses that were evaded vs. unique targets
            r.u_hits           # Num of uses that weren't evaded or missed vs. unique targets
            r.u_successes      # Num of *hits that dealt damage vs. unique targets
            r.u_crits          # Num of *hits that crit vs. unique targets
          ***********************************************************
          r.thp_dam            # Total HP Damage dealt
          r.tmp_dam            # Total MP Damage dealt
          r.ttp_dam            # Total TP Damage dealt
          r.thp_drain          # Total HP Drained
          r.tmp_drain          # Total MP Drained
          ***********************************************************
          r.added_states       # All states applied by last item/skill
          r.removed_states     # All states removed by last item/skill
          ***********************************************************

      Notes:
      (r.is_alive) is provided for easy reference. It is meant to be used
                  to prevent links from firing if the intended target is
                  already dead. Thus preventing a skill from unintentionally
                  jumping between targets. If added to a condition, ANY 
                  target death results in the failure of condition:. 

                  - Thus, to check if ALL targets lived, use r.is_alive
                  - To check if the initial target of an item/skill is alive, 
                    use r.targets[0].alive? 
                  - To check if all targets died, use r.all_dead
                    Remember that battle ends if all targets = all battlers.
                    So 'All Enemies' scoped skills with r.all_dead are moot.

      (r.hits) is the total number of non-missed and non-evaded skill uses.
                However, to check to see if a specific target was hit, 
                you'll need to reference the specific r.result[x].

      (r.result[x]) allows you to access each separate repeat of the previous
                  skill. So if you want to check the details of the 3rd 
                  attempt of a multi-hit skill to hit its target, you'd 
                  reference r.result[2].hit?

      (r.targets[x]) allows you to access each battler targeted by (but not 
                  necessarily effected by) the previous skill. You'd have to 
                  include r.result[x].hit? in the condition to make sure it 
                  didn't miss, or evade its target.

                  - All battler parameters can be referenced like normal.
                    i.e.: r.targets[x].hp will return the targets current HP

                    i.e.: r.targets[x].state?(50) will be true if the target
                        is effected by state_id(50). However if you want to
                        check if the last action resulted in the state, use
                        r.added_states.include?(50) instead. (See: Example 8)


  #---------------------------------------------------------------------------
  **Example Conditions
  #---------------------------------------------------------------------------
    Example 1: Does the attacker have more than half its MHP?

      condition: a.hp > (a.mhp * 0.5)

    Example 2: Did the linking skill hit at least once?

      condition: r.hits > 0

    Example 3: Did the last target die?

      condition: r.last.dead?

    Example 4: Did the linking skill deal at least 10% of the first targets 
                health in total damage?

      condition: r.thp_dam > (r.targets[0].mhp * 0.1)

    Example 5: Did the linking skill kill 2 or more enemies?

      condition: r.killed.length > 1

    Example 6: Was the linking skills first HIT target a darkspawn? 
                Requires Hime's Tag Manager

      condition: r.targets[0].tags.include?("darkspawn") && r.results[0].hit?

    Example 7: Was the LAST linked skill/item ID:5? 
                Note: if there is only one possible link item/skill, 'l' will 
                reference the original linking item/skill
   
      condition: l.id == 5

    Example 8: Did the linking skill poison(50) any targets?
   
      condition: r.added_states.include?(50)

    Example 9: Did the linking skill poison(50) the first target?
   
      condition: r.results[0].added_states.include?(50)

    Example 10: Is the first target weak against fire(3) damage?
   
      condition: r.targets[0].element_rate(3) > 1.0

#===============================================================================

=end


if $imported[:TH_SkillLinks]
#===============================================================================
# 
#===============================================================================
module RPG
  class UsableItem < BaseItem

    #-----------------------------------------------------------------------------
    # new:
    #-----------------------------------------------------------------------------
    def skill_link?
      return @has_skill_link if !@has_skill_link.nil?
      self.note =~ /(<link[-_ ]skill.*>)/i 
      self.note =~ /(<link[-_ ]item.*>)/i if !$1
      $1 ? @has_skill_link = true : @has_skill_link = false 
    end

    #-----------------------------------------------------------------------------
    # new:
    #-----------------------------------------------------------------------------
    def skill_links_conditional
      return @skill_links_conditional if @skill_links_conditional
      @skill_links_conditional = self.note.scan(/<link[-_ ]skill[-_ ]cond>(.*?)<\/link[-_ ]skill[-_ ]cond>/im)
    end

    #-----------------------------------------------------------------------------
    # new:
    #-----------------------------------------------------------------------------
    def item_links_conditional
      return @item_links_conditional if @item_links_conditional
      @item_links_conditional = self.note.scan(/<link[-_ ]item[-_ ]cond>(.*?)<\/link[-_ ]item[-_ ]cond>/im)
    end

    #-----------------------------------------------------------------------------
    # new:
    #-----------------------------------------------------------------------------
    def skill_links_conditional_data
      return @skill_links_conditional_data if @skill_links_conditional_data
      
      @skill_links_conditional_data = []
      stuff = self.skill_links_conditional
      stuff.each do |link|
        id = 0
        chance = 1
        condition = "true"
        free = false

        data = link[0].strip.split(/[\r\n]+/)
        for option in data
          case option
          when /id:\s*(\d+)/i
            id = $1.to_i
          when /chance:\s*(.*)/i
            chance = $1.to_f if $1
          when /condition:\s*(.*)/i
            condition = $1 if $1
          when /(<free_link>)/i
            free = true if $1
          end
        end
        cond_link = RD_Data_SkillLink.new(id)
        cond_link.chance = chance
        cond_link.condition = condition 
        cond_link.free = free 
        @skill_links_conditional_data << cond_link
      end
      return @skill_links_conditional_data
    end

    #-----------------------------------------------------------------------------
    # new:
    #-----------------------------------------------------------------------------
    def item_links_conditional_data
      return @item_links_conditional_data if @item_links_conditional_data
      
      @item_links_conditional_data = []
      stuff = self.item_links_conditional
      stuff.each do |link|
        id = 0
        chance = 1
        condition = "true"
        free = false

        data = link[0].strip.split("\r\n")
        for option in data
          case option
          when /id:\s*(\d+)/i
            id = $1.to_i
          when /chance:\s*(.*)/i
            chance = $1.to_f if $1
          when /condition:\s*(.*)/i
            condition = $1 if $1
          when /(<free_link>)/i
            free = true if $1
          end
        end
        cond_link = RD_Data_SkillLink.new(id)
        cond_link.chance = chance
        cond_link.condition = condition 
        cond_link.free = free 
        @item_links_conditional_data << cond_link
      end
      return @item_links_conditional_data
    end
  end #UsableItem
end #RPG



#===============================================================================
# new class:
#===============================================================================
class RD_Data_SkillLink
  attr_accessor :id
  attr_accessor :chance
  attr_accessor :condition
  attr_accessor :free

  #-----------------------------------------------------------------------------
  # new: 
  #-----------------------------------------------------------------------------
  def initialize(id)
    @id = id
    @chance = 1
    @condition = "false"
    @free = false
  end

  #-----------------------------------------------------------------------------
  # new:
  # a = actor using the item
  # l = last conditionally linked item 
  # r = results_stats (combo of all linked results)
  #-----------------------------------------------------------------------------
  def condition_met?(a, l, r, p=$game_party, t=$game_troop, v=$game_variables, s=$game_switches)
    return false if @condition.empty?
    eval(@condition)
  end
end



#===============================================================================
# new class:
#===============================================================================
class Linked_Results
  attr_reader :results    #Linkback to item_link_results
  attr_reader :is_alive   #Did any target die? 
  attr_reader :all_dead   #Did all targets die? 
  attr_reader :killed     #Array of battlers killed 
  attr_reader :targets    #(in order) All battlers targeted
  attr_reader :last       #Last battler targeted
  attr_reader :count      #Total uses 
  attr_reader :misses     #Num of results that did-not succeed
  attr_reader :successes  #Num of results that succeeded
  attr_reader :crits      #Num of successes that crit
  attr_reader :evades     #num of successes that were evaded
  attr_reader :hits       #num of hits (not missed not evaded)
  attr_reader :thp_dam   #
  attr_reader :tmp_dam   #
  attr_reader :ttp_dam   #
  attr_reader :thp_drain    #
  attr_reader :tmp_drain    #
  attr_reader :added_states     #
  attr_reader :removed_states   #

  attr_reader :u_targets   #(in order) total unique battlers targeted
  attr_reader :u_hits       #num of hits (not missed not evaded)
  attr_reader :u_evades     #num of hits that were evaded
  attr_reader :u_successes  #Num of hits that dealt damage
  attr_reader :u_crits      #Num of successes that crit

  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def initialize(item_link_results)
    @results = item_link_results
    @is_alive = true
    @all_dead = false
    @killed = []
    @targets = []
    @count = 0
    @misses = 0
    @successes = 0
    @crits = 0
    @evades = 0
    @hits = 0
    @thp_dam = 0
    @tmp_dam = 0
    @ttp_dam = 0
    @thp_drain = 0
    @tmp_drain = 0
    @added_states = []
    @removed_states = []

    @u_targets = [] #To collect unique targets list
    @u_successes = 0
    @u_crits = 0
    @u_evades = 0
    @u_hits = 0

    process_results(item_link_results)
  end

  #-----------------------------------------------------------------------------
  # new:
  # Need to create array of unique targets 
  #-----------------------------------------------------------------------------
  def process_results(item_link_results)
    unique = false
    cnt = 0
    lim = item_link_results.size
    while cnt < lim
    # item_link_results.each do |result|
      result = item_link_results[cnt]
      @last = result.battler
      unique = true if !@targets.include?(result.battler) #Target is unique if not already a target.
      @targets << result.battler

      if result.battler.dead?
        @is_alive   = false 
        @killed << result.battler
      end

      @count      += 1 if result.used     #For Comparisons.
      @misses     += 1 if result.missed   #For Comparisons.

      @hits       += 1 if result.hit?
      @u_hits     += 1 if result.hit? && unique
      @crits      += 1 if result.critical
      @u_crits    += 1 if result.critical && unique
      @evades     += 1 if result.evaded
      @u_evades   += 1 if result.evaded && unique
      @successes  += 1 if result.success
      @u_successes+= 1 if result.success && unique

      proc_hp_dam(result)
      proc_mp_dam(result)
      proc_tp_dam(result)
      proc_hp_drain(result)
      proc_hp_drain(result)

      # @added_states   = @added_states.concat(result.added_states)
      for id in result.added_states
        @added_states.push(id)
      end
      # @removed_states = @removed_states.concat(result.removed_states)
      for id in result.removed_states
        @removed_states.push(id)
      end

      unique = false
      cnt += 1
    end
    @u_targets = @targets.uniq #Can count # of unique targets
    @all_dead = true if @killed.length == @targets.length
  end

  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def proc_hp_dam(result)
    return 0 unless result.hp_damage > 0
    if result.success && !result.missed && !result.evaded
      @thp_dam += result.hp_damage
    else
    end
  end
  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def proc_mp_dam(result)
    return 0 unless result.mp_damage > 0
    if result.success && !result.missed && !result.evaded
      @tmp_dam += result.mp_damage
    end
  end
  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def proc_tp_dam(result)
    return 0 unless result.tp_damage > 0
    if result.success && !result.missed && !result.evaded
      @ttp_dam += result.tp_damage
    end
  end
  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def proc_hp_drain(result)
    return 0 unless result.hp_drain > 0
    if result.success && !result.missed && !result.evaded
      @thp_drain += result.hp_drain
    end
  end
  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def proc_hp_drain(result)
    return 0 unless result.mp_drain > 0
    if result.success && !result.missed && !result.evaded
      @tmp_drain += result.mp_drain
    end
  end

end



#===============================================================================
#
#===============================================================================
class Game_ActionResult
  attr_reader :battler
end



#===============================================================================
#
#===============================================================================
class Scene_Battle < Scene_Base

  #-----------------------------------------------------------------------------
  # alias overwrite:
  #-----------------------------------------------------------------------------
  def use_item
    @item_link_results = [] #First item result array.
    th_skill_links_use_item #Invoke Item(s) = fills array.
    check_item_links        #Uses array & repeats...
  end

  #-----------------------------------------------------------------------------
  alias :invoke_item_rdslp :invoke_item
  def invoke_item(target, item)
    invoke_item_rdslp(target, item)
    @item_link_results << target.result.clone
  end

  #-----------------------------------------------------------------------------
  # overwrite:
  #-----------------------------------------------------------------------------
  def check_item_links
    return if !@subject.current_action
    item = @subject.current_action.item
    return if !item.skill_link? #No links, do nothing.
    item.skill_links.each do |link_item|
      use_item_link(link_item)
    end

    if item.is_a?(RPG::Skill)
      process_skill_link_condition(item)
    else
      process_item_link_condition(item)
    end
  end
  #-----------------------------------------------------------------------------
  # overwrite:
  #-----------------------------------------------------------------------------
  def use_item_link(link_data)
    link_item = link_data.item

    @subject.use_item(link_item)

    refresh_status
    if link_item.is_a?(RPG::Skill)
      @subject.current_action.set_skill(link_item.id)
    else
      @subject.current_action.set_item(link_item.id)
    end
    targets = @subject.current_action.make_targets.compact
    targets.each do |target|    
      link_item.repeats.times do
        next unless link_data.condition_met?(@subject, target)
        invoke_item(target, link_item)
      end
    end
  end

  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def process_skill_link_condition(item)
    item.skill_links_conditional_data.each do |cond_link|
      link_item = $data_skills[cond_link.id]
      if link_conditions_met?(item, link_item, cond_link)
        invoke_skill_link(cond_link) 
      end
    end
  end

  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def process_item_link_condition(item)
    item.item_links_conditional_data.each do |cond_link|
      link_item = $data_items[cond_link.id]
      if link_conditions_met?(item, link_item, cond_link)
        invoke_item_link(cond_link) 
      end
    end
  end

  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def link_conditions_met?(orig_item, link_item, cond_link)
    return false if rand >= cond_link.chance
    @last_item ||= orig_item
    return false if !cond_link.condition_met?(@subject, @last_item, Linked_Results.new(@item_link_results) )
    @last_item = link_item
    return true
  end

  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def invoke_skill_link(cond_link, link_item = nil)
    link_item = $data_skills[cond_link.id] if !link_item
    @item_link_results = []

    unless cond_link.free
      @subject.use_item(link_item)
    else
      link_item.effects.each {|effect| @subject.item_global_effect_apply(effect) }
    end 

    refresh_status
    @subject.current_action.set_skill(link_item.id)
    targets = @subject.current_action.make_targets.compact
    # targets.each {|target| link_item.repeats.times { invoke_item(target, link_item) } } #Re-Fills Result array.
    cnt = 0
    lim = targets.size
    while cnt < lim
      link_item.repeats.times { invoke_item(targets[cnt], link_item)}
      cnt += 1
    end
  end

  #-----------------------------------------------------------------------------
  # new:
  #-----------------------------------------------------------------------------
  def invoke_item_link(cond_link, link_item = nil)
    link_item = $data_items[cond_link.id] if !link_item
    @item_link_results = []

    unless cond_link.free
      @subject.use_item(link_item)
    else
      link_item.effects.each {|effect| @subject.item_global_effect_apply(effect) }
    end 

    refresh_status
    @subject.current_action.set_item(link_item.id)
    targets = @subject.current_action.make_targets.compact
    # targets.each {|target| link_item.repeats.times { invoke_item(target, link_item) } }
    cnt = 0
    lim = targets.size
    while cnt < lim
      link_item.repeats.times { invoke_item(targets[cnt], link_item)}
      cnt += 1
    end
  end
end #Scene_Battle
end #Imported?



