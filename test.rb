STR = %{
      :param_rate     => [21, 'Param multipler'],          # Parameter
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
File.open("out.txt", 'w') do |file|
    cnt = 0
    STR.split(/[\r\n]+/).each do |line|
      cnt += 1
      if line =~ /'(.+)'/
        a = sprintf("'%s'", $1)
        puts "#{a},"
      else
        #puts "#{line}"
      end
    end
end