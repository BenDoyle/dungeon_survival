module Monster
  def value
    {
      id: monster_id.value,
      symbol: display_character.value,
      colour: display_colour.value,
      name: name.value,
      flags: monster_flags.value,
      resistances: monster_resistance_flags.value,
      mass: mass.value,
      experience: experience_modifier.value,
      genus: genus.value,
      species: species.value,
      holiness: holiness.value,
      resist_magic: resist_magic.value,
      atacks: attacks.value,
      hit_points: hit_points.value,
      ac: ac.value,
      evasion: evasion.value,
      spell_set: spell.value,
      corpse_class: corpse.value,
      zombie_size: zombie_size.value,
      shouts_set: shouts.value,
      inteligence: intel.value,
      habitat: habitat.value,
      flight_class: flight_class.value,
      speed: speed.value,
      energy_usage: energy_usage.value,
      uses: gmon_use_class.value,
      eats: gmon_eat_class.value,
      body_size: body_size.value,
    }
  end
end