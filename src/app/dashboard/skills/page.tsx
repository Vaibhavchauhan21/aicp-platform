import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

export default async function SkillsPage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/auth/login");
  }

  const { data: studentSkills, error } = await supabase
    .from("student_skills")
    .select(`
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
      </div>

      {studentSkills.length === 0 ? (
        <div className="mt-8 rounded-lg border bg-white p-8">
          <h2 className="text-xl font-semibold">
            No skills yet
          </h2>

          <p className="mt-2 text-gray-600">
            Your skills will appear here once they are added through
            assessments or your profile.
          </p>
        </div>
      ) : (
        <div className="mt-8 grid gap-4 md:grid-cols-2">
          {studentSkills.map((studentSkill, index) => {
            const skill = Array.isArray(studentSkill.skills)
              ? studentSkill.skills[0]
              : studentSkill.skills;

            return (
              <div
                key={`${studentSkill.level}-${skill?.name ?? index}`}
                className="rounded-lg border bg-white p-6"
              >
                <div className="flex items-start justify-between gap-4">
                  <div>
                    <h2 className="text-xl font-semibold">
                      {skill?.name ?? "Unknown skill"}
                    </h2>

                    {skill?.category && (
                      <p className="mt-1 text-sm text-gray-500">
                        {skill.category}
                      </p>
                    )}
                  </div>

                  {studentSkill.verified && (
                    <span className="rounded-full bg-green-100 px-3 py-1 text-xs font-medium text-green-700">
                      Verified
                    </span>
                  )}
                </div>

                <div className="mt-4">
                  <p className="text-sm text-gray-500">
                    Skill level
                  </p>

                  <p className="text-2xl font-bold">
                    {studentSkill.level}
                  </p>
                </div>

                <div className="mt-4">
                  <p className="text-sm text-gray-500">
                    Source
                  </p>

                  <p className="mt-1 capitalize">
                    {studentSkill.source}
                  </p>
                </div>

                {skill?.description && (
                  <p className="mt-4 text-sm text-gray-600">
                    {skill.description}
                  </p>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}