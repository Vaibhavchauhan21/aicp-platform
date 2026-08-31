"use client";

import Link from "next/link";
import { useState } from "react";

const navigation = [
  { name: "Dashboard", href: "/dashboard" },
  { name: "Profile", href: "/dashboard/profile" },
  { name: "My Skills", href: "/dashboard/skills" },
  { name: "Assessments", href: "/dashboard/assessments" },
  { name: "Career", href: "/dashboard/career" },
  { name: "Learning", href: "/dashboard/learning" },
  { name: "Opportunities", href: "/dashboard/opportunities" },
  { name: "Applications", href: "/dashboard/applications" },
  { name: "Resume", href: "/dashboard/resume" },
  { name: "Portfolio", href: "/dashboard/portfolio" },
];

export default function DashboardNav() {
  const [open, setOpen] = useState(false);

  return (
    <>
      <button
        type="button"
        onClick={() => setOpen(true)}
        aria-label="Open navigation"
        className="rounded-md p-2 hover:bg-gray-100"
      >
        <span className="block h-0.5 w-6 bg-gray-800" />
        <span className="mt-1.5 block h-0.5 w-6 bg-gray-800" />
        <span className="mt-1.5 block h-0.5 w-6 bg-gray-800" />
      </button>

      {open && (
        <div
          className="fixed inset-0 z-40 bg-black/30"
          onClick={() => setOpen(false)}
          aria-hidden="true"
        />
      )}

      <aside
        className={`fixed left-0 top-0 z-50 h-full w-72 transform bg-white p-6 shadow-xl transition-transform duration-200 ${
          open ? "translate-x-0" : "-translate-x-full"
        }`}
      >
        <div className="flex items-start justify-between">
          <div>
            <h2 className="text-2xl font-bold">AICP</h2>
            <p className="mt-1 text-xs text-gray-500">
              Academic & Career Intelligence Platform
            </p>
          </div>

          <button
            type="button"
            onClick={() => setOpen(false)}
            aria-label="Close navigation"
            className="rounded-md px-2 py-1 text-xl hover:bg-gray-100"
          >
            ×
          </button>
        </div>

        <nav className="mt-8 space-y-1">
          {navigation.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              onClick={() => setOpen(false)}
              className="block rounded-md px-3 py-2.5 text-sm font-medium hover:bg-gray-100"
            >
              {item.name}
            </Link>
          ))}
        </nav>

        <div className="mt-8 border-t pt-6">
          <Link
            href="/dashboard/settings"
            onClick={() => setOpen(false)}
            className="block rounded-md px-3 py-2.5 text-sm font-medium hover:bg-gray-100"
          >
            Settings
          </Link>
        </div>
      </aside>
    </>
  );
}