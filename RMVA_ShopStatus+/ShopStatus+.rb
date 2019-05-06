#=============================================================================#
#   Shop Item Status Plus                                                     #
#   Version: 1.1.1                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2019.05.06                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported[:CRDE_SISP] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2019.05.06: Add CRDE dependency                                          #
# -- 2019.05.02: Fix double page turning bug                                  #
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
#   > CRDE Kernel is required                                                 #
#   > CRDE Equipment info is required
#   > Place this script under my EquipComparsion script if you have it.       #
#   > Place this script under YEA's shop option script if you have it.        #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#                                                                             #
#   This script most of are the copies from my EECI script, so there're some  #
# variable/method name not changed.                                           #
#=============================================================================#

if !$imported[:CRDE_Kernel] || !$imported[:CRDE_EQInfo]
  raise LoadError, "CRDE Kernel and equipment info is required for ShopStatus+ script"
end

#=============================================================================
# * Module of this script
#=============================================================================
module CRDE
  module ShopItemStatusPlus
    include CRDE::RPG::Features
    include CRDE::RPG::EquipInfo
    #=====================================================================#
    # *                     v Free to Edit v                              #
    #=====================================================================#
    # * The next/last page keybind, edit the value for your own need.
    #---------------------------------------------------------------------
    Key_nextpage   = :RIGHT
    Key_lastpage   = :LEFT
    # Text displayed when nothing to show
    NothingText = "No Specials"

    #--------------------------------------------------------------------------
    # * Features that considered to compare
    ComparisonList = [
      # :param,
      :xparam,
      :sparam,
      :param_rate,
      :special_flag,
      :element_rate,
      :debuff_rate,
      :state_rate,
      :state_resist,
      :atk_element,
      :atk_state,
      :atk_speed,
      :atk_times,
      :stype_add,
      :stype_seal,
      :skill_add,
      :skill_seal,
      :equip_wtype,
      :equip_atype,
      :equip_fix,
      :equip_seal,
      :action_plus,
      :party_ability
    ]
    #=====================================================================#
    # Please don't edit anything below unless you know what you're doing! #
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
    ComparisonTable = {}
    ComparisonList.each do |key|
      ComparisonTable[key] = ParamNameTable[key]
    end
    
    Dummy = ::RPG::Weapon.new
    Dummy.features.clear
  end
end

#==============================================================================
# ** Window_ShopStatus
#==============================================================================
class Window_ShopStatus < Window_Base
  include CRDE::ShopItemStatusPlus
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
  # * Overwrite: update page next/last
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
  def inverse_color?(feature_id, data_id)
    return true if InverseColorFeature.include?(feature_id)
    if feature_id == FEATURE_STATE_RATE
      return true if !InverseColorStateID.include?(data_id)
    elsif feature_id == FEATURE_STATE_RESIST
      return true if InverseColorStateID.include?(data_id)
    end
    return false
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
      
      if inverse_color?(info.feature_id, info.data_id)
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
    delta *= -1 if inverse_color?(info.feature_id, info.data_id)
    change_color(param_change_color(delta))
    draw_diff_value(nrect, value[0], is_percent)
    change_color(normal_color)
  end
  #---------------------------------------------------------------------------
end
