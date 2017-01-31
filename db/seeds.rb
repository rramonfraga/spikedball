def create_skill_templates
  skill_file = IO.read('lib/assets/skill.json')
  skills = JSON.parse(skill_file)
  skills.each do |skill|
    SkillTemplate.create name: skill["name"], category: skill["category"], description: skill["description"]
  end
end

def create_team_templates
  team_file = IO.read('lib/assets/team.json')
  teams = JSON.parse(team_file)
  teams.each do |team|
    TeamTemplate.create name: team["name"], re_roll: team["re_roll"], description: team["description"],
                    stakes: team["stakes"], revive: team["revive"], apothecary: team["apothecary"]
  end
end


def create_player_templates
  team_file = IO.read('lib/assets/team.json')
  teams = JSON.parse(team_file)
  teams.each do |this_team|
    team = TeamTemplate.find_by(name: this_team["name"])
    this_team["players"].each do |player|
      new_player = team.player_templates.create quantity: player["quantity"], title: player["title"],
          cost: player["cost"], ma: player["ma"], st: player["st"], ag: player["ag"], av: player["av"],
          normal: player["normal"], double: player["double"], feeder: player["feeder"]

      player["skills"].each do |skill|
        skill_to_assign = SkillTemplate.find_by(name: skill["name"])
        new_player.skill_templates << skill_to_assign
      end
      new_player.save
    end
  end
end

def create_start_players
  start_file = IO.read('lib/assets/starts.json')
  starts = JSON.parse(start_file)
  starts.each do |start|
    sp = StartPlayer.create name: start["name"], cost: start["cost"], ma: start["ma"], st: start["st"],
                            ag: start["ag"], av: start["av"], feeder: start["feeder"]
    start["skills"].each do |skill|
      s = SkillTemplate.find_by(name: skill)
      sp.skill_templates << s
    end

    start["teams"].each do |team|
      t = TeamTemplate.find_by(name: team)
      sp.team_templates << t
    end
  end
end

def create_communities
  Community.create(name: 'Communities', code: 'communities')
  Community.create(name: 'Generación X', code: 'generacion-x')
  Community.create(name: 'Brick Bowl', code: 'brick-bowl')
end

def create_championships
  community = Community.find_by name: 'Generación X'
  community.championships.create name: "First League 2016 - 2017", kind: "League"
end

def create_team_and_players(user)
  random = Random.new
  random = random.rand(24) + 1
  team = user.teams.create name: "Team #{user.name}", team_template_id: random, re_rolls: 2, fan_factor: 0, assistant_coaches: 0, cheerleaders: 0, apothecaries: 0
  11.times do |index|
    number = team.team_template.player_templates.first.id
    team.players.create name: "Player #{index + 1}", dorsal: "#{index + 1}", player_template_id: number
  end
  championship = Championship.find_by(name: "First League 2016 - 2017")
  championship.join!(team)
  team.treasury = team.treasury - team.value
  team.save!
end

def create_users
  community = Community.find_by name: 'Generación X'
  users = []
  users << community.users.create(name: 'Rata', email: 'rataknight@gmail.com', password: 'SpikedBall')
  users << community.users.create(name: 'Avi', email: 'javitoms@hotmail.com', password: 'SpikedBall')
  users << community.users.create(name: 'Willas', email: 'rodri1984@gmail.com', password: 'SpikedBall')
  users << community.users.create(name: 'Azureh', email: 'diegobonilla@gmail.com', password: 'SpikedBall')
  users << community.users.create(name: 'Marilena', email: 'mmrromerodeavila@gmail.com', password: 'SpikedBall')
  users << community.users.create(name: 'Jamao', email: 'angel.brunodiaz@gmail.com', password: 'SpikedBall')
  users << community.users.create(name: 'Adamsemeth', email: 'adamsemeth@gmail.com', password: 'SpikedBall')
  users << community.users.create(name: 'Nacho', email: 'nolmedilla@gmail.com', password: 'SpikedBall')
  users << community.users.create(name: 'Kraven', email: 'kraven_88@msn.com', password: 'SpikedBall')
  #users << community.users.create(name: 'Bri', email: 'bri@spikedball.com', password: 'SpikedBall')
  users.each { |user| create_team_and_players(user) }
end


create_skill_templates
create_team_templates
create_player_templates
create_communities
create_championships
create_users
