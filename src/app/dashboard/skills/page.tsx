import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import SkillsManager from "./skills-manager";
export default async function SkillsPage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/auth/login");
  }
  const { data: availableSkills, error: skillsError } = await supabase
  .from("skills")
  .select("id, name")
  .order("name");
  const { data: studentSkills, error } = await supabase
  .from("student_skills")
  .select(`
    skill_id,
    level,
    source,
    verified,
    skills (
      name,
      category,
      description
    )
  `)
    .eq("student_id", user.id);
    if (skillsError) {
      return (
        <div>
          <h1 className="text-3xl font-bold">My Skills</h1>
    
          <p className="mt-4 text-red-600">
            Unable to load the skill catalog.
          </p>
    
          <p className="mt-2 text-sm text-gray-500">
            {skillsError.message}
          </p>
        </div>
      );
    }

  if (error) {
    return (
      <div>
        <h1 className="text-3xl font-bold">My Skills</h1>

        <p className="mt-4 text-red-600">
          Unable to load your skills.
        </p>

        <p className="mt-2 text-sm text-gray-500">
          {error.message}
        </p>
      </div>
    );
  }

  return (
    <div>
      <div>
        <h1 className="text-3xl font-bold">My Skills</h1>

        <p className="mt-2 text-gray-600">
          View and manage the skills associated with your AICP profile.
        </p>
        <SkillsManager
  availableSkills={availableSkills ?? []}
  studentSkills={studentSkills.map((studentSkill) => {
    const skill = Array.isArray(studentSkill.skills)
      ? studentSkill.skills[0]
      : studentSkill.skills;

    return {
      skillId: studentSkill.skill_id,
      name: skill?.name ?? "Unknown skill",
      level: Number(studentSkill.level),
      source: studentSkill.source,
      verified: studentSkill.verified,
    };
  })}
/>
      </div>
      </div>
      
  );
}