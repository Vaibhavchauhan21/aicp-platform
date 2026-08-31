"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";

export async function updateProfile(formData: FormData) {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    throw new Error("Unauthorized");
  }

  const fullName = String(formData.get("full_name") ?? "").trim();
  const phone = String(formData.get("phone") ?? "").trim();
  const location = String(formData.get("location") ?? "").trim();
  const bio = String(formData.get("bio") ?? "").trim();

  const degree = String(formData.get("degree") ?? "").trim();
  const branch = String(formData.get("branch") ?? "").trim();
  const graduationYearValue = String(
    formData.get("graduation_year") ?? ""
  ).trim();

  const graduationYear = graduationYearValue
    ? Number(graduationYearValue)
    : null;

  if (
    graduationYear !== null &&
    (!Number.isInteger(graduationYear) ||
      graduationYear < 1900 ||
      graduationYear > 2100)
  ) {
    throw new Error("Invalid graduation year");
  }

  const { error: profileError } = await supabase
    .from("profiles")
    .update({
      full_name: fullName || null,
      phone: phone || null,
      location: location || null,
      bio: bio || null,
    })
    .eq("id", user.id);

  if (profileError) {
    throw new Error(profileError.message);
  }

  const { error: studentError } = await supabase
    .from("students")
    .update({
      degree: degree || null,
      branch: branch || null,
      graduation_year: graduationYear,
    })
    .eq("id", user.id);

  if (studentError) {
    throw new Error(studentError.message);
  }

  revalidatePath("/dashboard/profile");
  revalidatePath("/dashboard");

  return { success: true };
}