import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import ProfileForm from "./profile-form";

export default async function ProfilePage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/auth/login");
  }

  const [{ data: profile, error: profileError }, { data: student, error: studentError }] =
    await Promise.all([
      supabase
        .from("profiles")
        .select("full_name, avatar_url, phone, location, bio, role")
        .eq("id", user.id)
        .single(),

      supabase
      .from("students")
      .select(`
        institution_id,
        degree,
        branch,
        graduation_year,
        interests,
        institutions (
          name,
          type,
          location
        )
      `)
      .eq("id", user.id)
      .single(),
    ]);

  if (profileError || studentError) {
    return (
      <div>
        <h1 className="text-3xl font-bold">My Profile</h1>

        <p className="mt-4 text-red-600">
          Unable to load your profile.
        </p>

        {profileError && (
          <p className="mt-2 text-sm text-gray-500">
            Profile: {profileError.message}
          </p>
        )}

        {studentError && (
          <p className="mt-2 text-sm text-gray-500">
            Student: {studentError.message}
          </p>
        )}
      </div>
    );
  }

  return (
    <div className="max-w-4xl">
      <div>
        <h1 className="text-3xl font-bold">My Profile</h1>
  
        <p className="mt-2 text-gray-600">
          Update your personal and academic information.
        </p>
      </div>
  
      <ProfileForm
        fullName={profile.full_name ?? ""}
        phone={profile.phone ?? ""}
        location={profile.location ?? ""}
        bio={profile.bio ?? ""}
        degree={student.degree ?? ""}
        branch={student.branch ?? ""}
        graduationYear={student.graduation_year}
        institutionName={
          Array.isArray(student.institutions)
            ? student.institutions[0]?.name ?? ""
            : student.institutions?.name ?? ""
        }
      />
    </div>
  );
  }