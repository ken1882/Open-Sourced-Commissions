=begin
#===============================================================================
 Title: Item Affix Rarity
 Author: Hime
 Date: Mar 25, 2014
 URL: http://www.himeworks.com/2014/03/25/item-affix-rarity/
--------------------------------------------------------------------------------
 ** Change log
 Mar 25, 2014
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
 
 This script is an add-on for Item Rarity. It allows equips to inherit rarity
 from any affixes.
 
 For example, if an item has a rarity level of 1, but then
 has a prefix with rarity level 4 added, the item's rarity is now increased
 to 4 because of the prefix.
 
--------------------------------------------------------------------------------
 ** Installation
 
 In the script editor, place this script below Item Affixes, Item Rarity,
 and above Main

--------------------------------------------------------------------------------
 ** Usage 
 
 Note-tag prefixes or suffixes with
 
   <item rarity: x>
   
 Where x is a number.
 The rarity for the item will be automatically computed.
 
#===============================================================================
=end
$imported = {} if $imported.nil?
$imported[:TH_ItemAffixRarity] = true
#===============================================================================
# ** Configuration
#===============================================================================
module TH
  module Item_Affix_Rarity
  end
end
#===============================================================================
# ** Rest of script
#===============================================================================
module RPG
  class EquipItem < BaseItem
    
    alias :th_affix_rarity_make_item_rarity :make_item_rarity
    def make_item_rarity(rarity)
      rarity = th_affix_rarity_make_item_rarity(rarity)
      rarity = apply_affix_item_rarity
      rarity
    end
    
    #---------------------------------------------------------------------------
    # Assumes it takes the max of all rarities
    #---------------------------------------------------------------------------
    def apply_affix_item_rarity
      arr = [self.rarity]
      arr << prefix.rarity if prefix
      arr << suffix.rarity if suffix
      return arr.max
    end
  end
end

