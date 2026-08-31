"use client";

import { useState } from "react";
import { updateProfile } from "./actions";

type ProfileFormProps = {
  fullName: string;
  phone: string;
  location: string;
  bio: string;
  degree: string;
  branch: string;
  graduationYear: number | null;
};

export default function ProfileForm({
  fullName,
  phone,
  location,
  bio,
  degree,
  branch,
  graduationYear,
}: ProfileFormProps) {
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState("");

  async function handleSubmit(formData: FormData) {
    setSaving(true);
    setMessage("");

    try {
      await updateProfile(formData);
      setMessage("Profile updated successfully.");
    } catch (error) {
      setMessage(
        error instanceof Error
          ? error.message
          : "Unable to update profile."
      );
    } finally {
      setSaving(false);
    }
  }

  return (
    <form action={handleSubmit} className="mt-8 space-y-8">
      <section className="rounded-lg border bg-white p-6">
        <h2 className="text-xl font-semibold">
          Personal Information
        </h2>

        <div className="mt-6 grid gap-5 md:grid-cols-2">
          <div>
            <label
              htmlFor="full_name"
              className="block text-sm font-medium"
            >
              Full name
            </label>

            <input
              id="full_name"
              name="full_name"
              defaultValue={fullName}
              className="mt-2 w-full rounded-md border px-3 py-2"
            />
          </div>

          <div>
            <label
              htmlFor="phone"
              className="block text-sm font-medium"
            >
              Phone
            </label>

            <input
              id="phone"
              name="phone"
              type="tel"
              defaultValue={phone}
              className="mt-2 w-full rounded-md border px-3 py-2"
            />
          </div>

          <div>
            <label
              htmlFor="location"
              className="block text-sm font-medium"
            >
              Location
            </label>

            <input
              id="location"
              name="location"
              defaultValue={location}
              className="mt-2 w-full rounded-md border px-3 py-2"
            />
          </div>

          <div className="md:col-span-2">
            <label
              htmlFor="bio"
              className="block text-sm font-medium"
            >
              Bio
            </label>

            <textarea
              id="bio"
              name="bio"
              rows={4}
              defaultValue={bio}
              className="mt-2 w-full rounded-md border px-3 py-2"
            />
          </div>
        </div>
      </section>

      <section className="rounded-lg border bg-white p-6">
        <h2 className="text-xl font-semibold">
          Academic Information
        </h2>

        <div className="mt-6 grid gap-5 md:grid-cols-2">
          <div>
            <label
              htmlFor="degree"
              className="block text-sm font-medium"
            >
              Degree
            </label>

            <input
              id="degree"
              name="degree"
              defaultValue={degree}
              placeholder="e.g. B.Tech"
              className="mt-2 w-full rounded-md border px-3 py-2"
            />
          </div>

          <div>
            <label
              htmlFor="branch"
              className="block text-sm font-medium"
            >
              Branch
            </label>

            <input
              id="branch"
              name="branch"
              defaultValue={branch}
              placeholder="e.g. Computer Science"
              className="mt-2 w-full rounded-md border px-3 py-2"
            />
          </div>

          <div>
            <label
              htmlFor="graduation_year"
              className="block text-sm font-medium"
            >
              Graduation year
            </label>

            <input
              id="graduation_year"
              name="graduation_year"
              type="number"
              min="1900"
              max="2100"
              defaultValue={graduationYear ?? ""}
              className="mt-2 w-full rounded-md border px-3 py-2"
            />
          </div>
        </div>
      </section>

      <div className="flex items-center gap-4">
        <button
          type="submit"
          disabled={saving}
          className="rounded-md bg-black px-5 py-2.5 text-white disabled:opacity-50"
        >
          {saving ? "Saving..." : "Save changes"}
        </button>

        {message && (
          <p className="text-sm text-gray-600">
            {message}
          </p>
        )}
      </div>
    </form>
  );
}