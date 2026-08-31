import Link from "next/link";
import DashboardNav from "./dashboard-nav";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen bg-gray-50">
      <header className="sticky top-0 z-30 border-b bg-white">
        <div className="flex h-16 items-center justify-between px-4 sm:px-6 lg:px-8">
          <div className="flex items-center gap-4">
            <DashboardNav />

            <Link
              href="/dashboard"
              className="text-xl font-bold tracking-tight"
            >
              AICP
            </Link>
          </div>

          <div className="flex items-center gap-3">
            <span className="hidden text-sm text-gray-500 sm:block">
              Student Portal
            </span>

            <Link
              href="/dashboard/profile"
              className="rounded-md border px-3 py-2 text-sm font-medium hover:bg-gray-50"
            >
              Profile
            </Link>
          </div>
        </div>
      </header>

      <main className="mx-auto w-full max-w-7xl p-6 sm:p-8">
        {children}
      </main>
    </div>
  );
}