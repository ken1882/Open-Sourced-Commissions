#=============================================================================#
#   EECI Patch - Skill Description                                            #
#   Version: 1.0.1                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2018.05.13                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported[:CRDE_EECISKDEC] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2019.05.13: Start the script and completed                               #
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
#       This script will allow you add a tag to the skill, that in status     #
# window it will shows the description of the tagged skill and also be able   #
# to linewrap.                                                                #
# Will only work if you have proper script installed, such as EECI.           #
#        Add this to the note box of the skill, with a new line:              #
#                               <diff desc>                                   #
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > Require: CRDE Kernel                                                    #
#   > Require: CRDE Equipment Info                                            #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#                                                                             #
#=============================================================================#

if !$imported[:CRDE_Kernel] || !$imported[:CRDE_EQInfo]
  raise LoadError, "Required scripts for `EECI Skill Description` script not found"
elsif CRDE::Kernel::Version < "0.1.2"
  raise LoadError, "Require CRDE Kernel version >= 0.1.2"
end
#=============================================================================
# * Module of this script
#=============================================================================
module CRDE
  #=============================================================================
  module RPG::Features
    FEATURE_SKILL_DESCRIPTION = :diff_skdec
  end
  #=============================================================================
  module RPG::EquipInfo
    include CRDE::RPG::Features

    DiffDescSkilTag = "<\\diffskilldesc>"
    DescSkillRegex  = /<diff(.?)desc>/i
    DescSkillList   = []
    ::DataManager.register_notetag_listener(:skill, Proc.new{|obj|
      if obj.note.split(/[\r\n]+/).any?{|line| line =~ DescSkillRegex}
        DescSkillList.push(obj.id) 
      end
    })
  end
end
#==============================================================================
if $imported[:CRDE_EECI]
#==============================================================================
# ** Window_EquipStatus
#==============================================================================
class Window_EquipStatus < Window_Base
  include CRDE::RPG::EquipInfo
  #---------------------------------------------------------------------------
  alias :get_feature_name_skdec :get_feature_name
  def get_feature_name(feature_id, index = nil)
    if feature_id == FEATURE_SKILL_ADD && index && DescSkillList.include?(index)
      return DiffDescSkilTag
    end
    return get_feature_name_skdec(feature_id, index)
  end
  #---------------------------------------------------------------------------
  alias :push_new_comparison_skdec :push_new_comparison
  def push_new_comparison(stage, info)
    if info.display_str.include?(DiffDescSkilTag)
      push_group_info(stage, info)
      process_skill_description(stage, info)
    else
      push_new_comparison_skdec(stage, info)
    end
  end
  #---------------------------------------------------------------------------
  def process_skill_description(stage, info)
    info.feature_id = FEATURE_SKILL_DESCRIPTION
    text = sprintf("+ %s", $data_skills[info.data_id].description)
    text = CRDE::Kernel::textwrap(text, @ori_contents_width, self.contents)
    text.each do |line|
      inf = info.dup
      inf.display_str = ' ' + line
      push_skill_description(stage, inf)
    end
    process_compare_break(stage) if @current_line_number >= line_max
  end
  #---------------------------------------------------------------------------
  def push_skill_description(stage, info)
    if stage == :current || (stage == :eqset && @last_stage == :current)
      @base_pages << info
    else
      @pages << info
    end
    @current_line_number += 1
  end
  #---------------------------------------------------------------------------
  alias :draw_item_skdesc :draw_item
  def draw_item(dx, dy, info)
    if info.feature_id == FEATURE_SKILL_DESCRIPTION
      draw_skill_desc_diff(dx,dy,info)
    else
      draw_item_skdesc(dx, dy, info)
    end
  end
  #---------------------------------------------------------------------------
  def draw_skill_desc_diff(dx, dy, info)
    a = (info.value ? 1 : 0)
    b = (info.value ? 0 : 1)
    if inverse_color?(info.feature_id, info.data_id)
      a ^= 1; b ^= 1;
    end
    change_color(param_change_color(a - b))
    rect = Rect.new(dx, dy, @ori_contents_width-4, line_height)
    draw_text(rect, info.display_str)
  end
  #---------------------------------------------------------------------------
end
end # EECI imported