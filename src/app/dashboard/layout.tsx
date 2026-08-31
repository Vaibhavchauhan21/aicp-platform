import Link from "next/link";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen bg-gray-50">
      <div className="flex min-h-screen">
        <aside className="w-64 border-r bg-white p-6">
          <div className="mb-8">
            <h1 className="text-2xl font-bold">AICP</h1>
            <p className="mt-1 text-sm text-gray-500">
              Academic & Career Intelligence Platform
            </p>
          </div>

          <nav className="space-y-2">
            <Link
              href="/dashboard"
              className="block rounded-md px-3 py-2 hover:bg-gray-100"
            >
              Dashboard
            </Link>

            <Link
              href="/dashboard/skills"
              className="block rounded-md px-3 py-2 hover:bg-gray-100"
            >
              My Skills
            </Link>

            <Link
              href="/dashboard/assessments"
              className="block rounded-md px-3 py-2 hover:bg-gray-100"
            >
              Assessments
            </Link>

            <Link
              href="/dashboard/career"
              className="block rounded-md px-3 py-2 hover:bg-gray-100"
            >
              Career
            </Link>

            <Link
              href="/dashboard/learning"
              className="block rounded-md px-3 py-2 hover:bg-gray-100"
            >
              Learning
            </Link>

            <Link
              href="/dashboard/opportunities"
              className="block rounded-md px-3 py-2 hover:bg-gray-100"
            >
              Opportunities
            </Link>

            <Link
              href="/dashboard/applications"
              className="block rounded-md px-3 py-2 hover:bg-gray-100"
            >
              Applications
            </Link>

            <Link
              href="/dashboard/resume"
              className="block rounded-md px-3 py-2 hover:bg-gray-100"
            >
              Resume
            </Link>

            <Link
              href="/dashboard/portfolio"
              className="block rounded-md px-3 py-2 hover:bg-gray-100"
            >
              Portfolio
            </Link>
          </nav>

          <div className="mt-8 border-t pt-6">
            <Link
              href="/dashboard/settings"
              className="block rounded-md px-3 py-2 hover:bg-gray-100"
            >
              Settings
            </Link>
          </div>
        </aside>

        <section className="flex-1">
          <header className="border-b bg-white px-8 py-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-500">AICP Student Portal</p>
              </div>

              <Link
                href="/dashboard"
                className="rounded-md border px-4 py-2 text-sm hover:bg-gray-50"
              >
                Account
              </Link>
            </div>
          </header>

          <main className="p-8">{children}</main>
        </section>
      </div>
    </div>
  );
}