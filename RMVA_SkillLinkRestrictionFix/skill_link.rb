=begin
#===============================================================================
 Title: Skill Links
 Author: Hime
 Date: Feb 15, 2015
 URL: http://www.himeworks.com/2014/03/30/skill-links/
--------------------------------------------------------------------------------
 ** Change log
 Feb 15, 2014
   - fixed typo
 Dec 1, 2014
   - Implemented skill link conditions
 Jul 14, 2014
   - skill links are not activated if there is no current action
 Mar 30, 2014
   - Initial release
--------------------------------------------------------------------------------   
 ** Terms of Use
 * Free to use in non-commercial projects
 * Contact me for commercial use
 * No real support. The script is provided as-is
 * Will do bug fixes, but no compatibility patches
 * Features may be requested but no guarantees, especially if it is non-trivial
 * Credits to Hime Works in your project
 * Preserve this header
--------------------------------------------------------------------------------
 ** Description
 
 This script allows you to create "skill links" which are basically a way to
 connect skill effects together.
 
 Skill links are purely a development concept: they are created to allow you
 to specify multiple behavior that should occur when a single skill is used.
 In particular, it allows a single skill to execute damage formulas and effects
 under different scopes.
 
 For example, suppose you wanted to create a skill that damages the enemies,
 but also heals all allies as a secondary effect. By default, there is no easy
 way to accomplish this without resorting to common events or complex formulas,
 and even that may have its own limitations.
 
 However, there are few  things that you CAN do.
 It is easy to create a skill that will damage all enemies
 It is also easy to create a skill that will heal all allies.
 
 This script introduces the link between the two skills: you simply specify the
 healing skill as a "linked skill" to the damaging skill, and now whenever you
 execute the damaging skill, the healing skill will automatically run as well.

--------------------------------------------------------------------------------
 ** Installation
 
 In the script editor, place this script below Materials and above Main

--------------------------------------------------------------------------------
 ** Usage 
 
 To create a skill link, note-tag a skill or item with
 
   <link skill: ID>
   
 Where ID is the ID of the skill you want to link.
 
 You can also create item links. Note-tag a skill or item with
 
   <link item: ID>
   
 Where ID is the ID of the item you want to link.
 
 You can have items linked to skills, or skills linked to items.
 
 -- Link Conditions --
 
 You can create link conditions. These conditions specify whether the linked
 skill or item will be executed. They will be executed only if the conditions
 are met.
 
 To create a link condition, use the note-tag
 
   <link condition: link_ID>
     FORMULA
   </link condition>
   
 Where the link ID is the ID of the link data that you created earlier.
 The ID is assigned based on the order that they appear, so the very first
 <link skill> tag is ID 1, the next is ID 2, and so on.
 
 The following variables are available

   a - action user
   b - action target
   p - game party
   t - game troop
   s - game switches
   v - game variables

--------------------------------------------------------------------------------
 ** Notes
 
 This script does not play animations for skill links. 
 
#===============================================================================
=end
$imported = {} if $imported.nil?
$imported[:TH_SkillLinks] = true
#===============================================================================
# ** Configuration
#===============================================================================
module TH
  module Skill_Links
    Regex = /<(link[-_ ]item|link[-_ ]skill):\s*(\d+)\s*>/i    
    Cond_Regex = /<link[-_ ]condition:\s*(\d+)\s*>(.*?)<\/link[-_ ]condition>/im
  end
end
#===============================================================================
# ** Rest of script
#===============================================================================
module RPG
  class UsableItem < BaseItem
    
    def skill_links
      load_notetag_skill_links unless @skill_links
      return @skill_links
    end
    
    def load_notetag_skill_links
      @skill_links = []
      results = self.note.scan(TH::Skill_Links::Regex)
      results.each do |res|
        data = Data_SkillLink.new
        data.id = res[1].to_i
        if res[0] =~ /skill/i
          data.type = :skill
        else
          data.type = :item
        end
        @skill_links << data
      end
      
      results = self.note.scan(TH::Skill_Links::Cond_Regex)
      results.each do |res|
        id = res[0].to_i
        cond = res[1].strip
        @skill_links[id-1].condition = cond
      end
    end
  end
end

class Data_SkillLink

  attr_accessor :id
  attr_accessor :type
  attr_accessor :condition
  
  def initialize
    @type = nil
    @id = 0
    @condition = ""
  end
  
  def item
    return $data_skills[@id] if @type == :skill
    return $data_items[@id] if @type == :item
  end
  
  def condition_met?(user, target)
    return true if @condition.empty?
    return eval_condition(user, target)
  end
  
  def eval_condition(a, b, p=$game_party, t=$game_troop, s=$game_switches, v=$game_variables)
    eval(@condition)
  end
end

class Scene_Battle < Scene_Base
  
  alias :th_skill_links_use_item :use_item
  def use_item
    th_skill_links_use_item
    check_item_links
  end

  def check_item_links
    return unless @subject.current_action
    item = @subject.current_action.item
    item.skill_links.each do |link_data|
      
      use_item_link(link_data)
    end
  end
  
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
end