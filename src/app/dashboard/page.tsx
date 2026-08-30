import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

export default async function DashboardPage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/auth/login");
  }

  const { data: profile, error } = await supabase
    .from("profiles")
    .select("full_name, role")
    .eq("id", user.id)
    .single();

  if (error || !profile) {
    return (
      <main className="min-h-screen flex items-center justify-center p-6">
        <div>
          <h1 className="text-2xl font-bold">
            Profile not found
          </h1>

          <p className="mt-2 text-gray-600">
            Your account exists, but your AICP profile could not be loaded.
          </p>
        </div>
      </main>
    );
  }

  return (
    <main className="min-h-screen p-8">
      <div className="mx-auto max-w-5xl">
        <h1 className="text-4xl font-bold">
          Welcome, {profile.full_name}
        </h1>

        <p className="mt-2 text-gray-600">
          AICP Dashboard
        </p>

        <div className="mt-8 rounded-lg border p-6">
          <h2 className="text-xl font-semibold">
            Your account
          </h2>

          <p className="mt-3">
            <strong>Role:</strong>{" "}
            {profile.role}
          </p>

          <p className="mt-2">
            <strong>Email:</strong>{" "}
            {user.email}
          </p>
        </div>
        <form action="/auth/logout" method="POST" className="mt-8">
  <button
    type="submit"
    className="rounded-md bg-black px-4 py-2 text-white"
  >
    Sign out
  </button>
</form>
      </div>
    </main>
  );
}