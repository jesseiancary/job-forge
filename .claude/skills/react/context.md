# React Skill Context

This skill is auto-loaded when working on React components (`.tsx` files) or frontend development tasks.

## Project Structure

The frontend follows **feature-based organization** for Job-Forge:

```
apps/web/src/
├── features/               # Feature-based modules
│   ├── resumes/
│   │   ├── components/     # Resume-specific components
│   │   │   ├── ResumeList.tsx
│   │   │   ├── ResumeEditor.tsx
│   │   │   ├── VariantCard.tsx
│   │   │   └── DeleteVariantDialog.tsx
│   │   ├── hooks/          # Resume-specific hooks
│   │   │   ├── useResumeVariants.ts  # GraphQL queries
│   │   │   └── useResumeMutations.ts # GraphQL mutations
│   │   ├── types.ts        # Resume-specific types
│   │   ├── ResumesPage.tsx # Page component
│   │   └── EditResumePage.tsx
│   ├── applications/
│   │   ├── components/
│   │   │   ├── ApplicationList.tsx
│   │   │   ├── ApplicationCard.tsx
│   │   │   └── NewApplicationModal.tsx
│   │   ├── hooks/
│   │   │   ├── useApplications.ts
│   │   │   └── useApplicationMutations.ts
│   │   ├── types.ts
│   │   └── ApplicationsPage.tsx
│   ├── personal-info/
│   │   ├── components/
│   │   │   ├── PersonalInfoForm.tsx
│   │   │   └── SignatureUpload.tsx
│   │   ├── hooks/
│   │   │   └── usePersonalInfo.ts  # REST API (not GraphQL)
│   │   └── PersonalInfoPage.tsx
│   └── auth/              # Phase 2 only
│       ├── components/
│       │   ├── LoginForm.tsx
│       │   └── RegisterForm.tsx
│       ├── hooks/
│       │   └── useAuth.ts
│       └── LoginPage.tsx
├── shared/                 # Shared UI components and utilities
│   ├── components/
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Modal.tsx
│   │   ├── ErrorMessage.tsx
│   │   ├── LoadingSpinner.tsx
│   │   ├── EmptyState.tsx
│   │   └── Layout.tsx
│   ├── hooks/
│   │   ├── useLocalStorage.ts
│   │   ├── useDebounce.ts
│   │   └── useDisclosure.ts
│   └── utils/
│       ├── formatters.ts
│       └── validators.ts
├── lib/                    # Core infrastructure
│   ├── apollo-client.ts    # Apollo Client configuration
│   ├── axios-client.ts     # Axios for REST endpoints (personal-info, uploads)
│   └── router.tsx          # React Router configuration
├── graphql/                # GraphQL queries and mutations
│   ├── queries/
│   │   ├── resumes.ts
│   │   └── applications.ts
│   ├── mutations/
│   │   ├── resumes.ts
│   │   └── applications.ts
│   └── fragments/
│       └── resume.ts
├── App.tsx                 # Root component
└── main.tsx                # Entry point
```

**Why feature-based?**

- Features are self-contained and easier to reason about
- Easier to delete a feature (delete one folder)
- Scales better than `/components`, `/hooks`, `/utils` at root
- Mirrors how developers think about the product

## State Management Strategy

### Server State → Apollo Client (GraphQL) + Axios (REST)

**NEVER store API response data in `useState` or Context** — Apollo Client handles caching, refetching, and normalization for GraphQL. Axios + React state for simple REST endpoints.

#### GraphQL Data (Apollo Client)

```tsx
import { useQuery, useMutation, gql } from '@apollo/client'

// GraphQL query
const GET_RESUME_VARIANTS = gql`
  query GetResumeVariants {
    resumeVariants {
      id
      name
      content {
        professionalSummary
        experience {
          id
          company
          title
          bullets
        }
      }
      createdAt
    }
  }
`

// ✅ GOOD - GraphQL data in Apollo Client
function ResumeList() {
  const { data, loading, error } = useQuery(GET_RESUME_VARIANTS)

  if (loading) return <LoadingSpinner />
  if (error) return <ErrorMessage error={error} />

  return (
    <div>
      {data?.resumeVariants.map((variant) => (
        <VariantCard key={variant.id} variant={variant} />
      ))}
    </div>
  )
}

// ❌ BAD - GraphQL data in useState
function ResumeList() {
  const [variants, setVariants] = useState([])

  useEffect(() => {
    fetch('/graphql', {
      method: 'POST',
      body: JSON.stringify({ query: '...' }),
    })
      .then((res) => res.json())
      .then((data) => setVariants(data.data.resumeVariants))
  }, [])

  // ...
}
```

#### REST Data (Axios)

For simple REST endpoints (personal-info, file uploads):

```tsx
import { useState, useEffect } from 'react'
import { api } from '@/lib/axios-client'
import type { PersonalInfo } from '@/types'

// ✅ GOOD - Simple REST endpoint with useState
function usePersonalInfo() {
  const [data, setData] = useState<PersonalInfo | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  useEffect(() => {
    api
      .get<PersonalInfo>('/api/v1/personal-info')
      .then((res) => {
        setData(res.data)
        setLoading(false)
      })
      .catch((err) => {
        setError(err)
        setLoading(false)
      })
  }, [])

  const updatePersonalInfo = async (updates: Partial<PersonalInfo>) => {
    const res = await api.patch<PersonalInfo>('/api/v1/personal-info', updates)
    setData(res.data)
  }

  return { data, loading, error, updatePersonalInfo }
}
```

### Global Client State → React Context (Phase 2)

Use Context for:

- **Authentication state** (current user, access token) - Phase 2 only
- **Theme** (light/dark mode)
- **Global UI state** (sidebar open/closed)

**Note:** Phase 1 (MVP) has NO authentication, so most Context is unnecessary.

**Example: Auth Context (Phase 2)**

```tsx
// features/auth/context/AuthContext.tsx
import { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import type { User } from '@/types'

interface AuthContextValue {
  user: User | null
  accessToken: string | null
  login: (token: string, user: User) => void
  logout: () => void
  isAuthenticated: boolean
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [accessToken, setAccessToken] = useState<string | null>(() =>
    localStorage.getItem('accessToken'),
  )

  const login = (token: string, user: User) => {
    setAccessToken(token)
    setUser(user)
    localStorage.setItem('accessToken', token)
  }

  const logout = () => {
    setAccessToken(null)
    setUser(null)
    localStorage.removeItem('accessToken')
  }

  return (
    <AuthContext.Provider
      value={{
        user,
        accessToken,
        login,
        logout,
        isAuthenticated: !!accessToken,
      }}
    >
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider')
  }
  return context
}
```

### Local Component State → useState / useReducer

Use for:

- Form input values (controlled components)
- Modal open/closed state
- Accordion expanded/collapsed
- Client-side filtering/sorting (before sending to API)

```tsx
function NewApplicationModal() {
  const [companyName, setCompanyName] = useState('')
  const [jobTitle, setJobTitle] = useState('')
  const [selectedVariantId, setSelectedVariantId] = useState<string | null>(null)
  const [isOpen, setIsOpen] = useState(false)

  // ...
}
```

### URL State → React Router

Use for:

- Current page/route
- Search filters (query params)
- Selected resource ID

```tsx
import { useParams, useSearchParams } from 'react-router-dom'

function EditResumePage() {
  const { variantId } = useParams<{ variantId: string }>()
  const [searchParams, setSearchParams] = useSearchParams()

  const section = searchParams.get('section') ?? 'experience'

  // ...
}
```

## Apollo Client Patterns

### Apollo Client Configuration

```tsx
// lib/apollo-client.ts
import { ApolloClient, InMemoryCache, createHttpLink } from '@apollo/client'
import { setContext } from '@apollo/client/link/context'

const httpLink = createHttpLink({
  uri: '/graphql',
})

const authLink = setContext((_, { headers }) => {
  const token = localStorage.getItem('accessToken')
  return {
    headers: {
      ...headers,
      authorization: token ? `Bearer ${token}` : '',
    },
  }
})

export const apolloClient = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache({
    typePolicies: {
      Query: {
        fields: {
          resumeVariants: {
            merge: false, // Replace array instead of merging
          },
        },
      },
    },
  }),
})
```

### GraphQL Queries

```tsx
// graphql/queries/resumes.ts
import { gql } from '@apollo/client'

export const GET_RESUME_VARIANTS = gql`
  query GetResumeVariants {
    resumeVariants {
      id
      name
      description
      content {
        professionalSummary
        experience {
          id
          company
          title
          dates
          bullets
        }
        education {
          id
          school
          degree
          graduationDate
        }
        skills
      }
      createdAt
      updatedAt
    }
  }
`

export const GET_RESUME_VARIANT = gql`
  query GetResumeVariant($id: ID!) {
    resumeVariant(id: $id) {
      id
      name
      description
      content {
        professionalSummary
        experience {
          id
          company
          title
          dates
          bullets
        }
        education {
          id
          school
          degree
          graduationDate
        }
        skills
      }
      createdAt
      updatedAt
    }
  }
`
```

### GraphQL Mutations

```tsx
// graphql/mutations/resumes.ts
import { gql } from '@apollo/client'

export const CREATE_RESUME_VARIANT = gql`
  mutation CreateResumeVariant($input: CreateResumeVariantInput!) {
    createResumeVariant(input: $input) {
      id
      name
      description
      createdAt
    }
  }
`

export const UPDATE_RESUME_VARIANT = gql`
  mutation UpdateResumeVariant($id: ID!, $input: UpdateResumeVariantInput!) {
    updateResumeVariant(id: $id, input: $input) {
      id
      name
      description
      content {
        professionalSummary
        experience {
          id
          company
          title
          bullets
        }
      }
      updatedAt
    }
  }
`

export const DELETE_RESUME_VARIANT = gql`
  mutation DeleteResumeVariant($id: ID!) {
    deleteResumeVariant(id: $id)
  }
`
```

### Mutations with Cache Updates

Apollo Client automatically updates the cache when objects have `__typename` and `id`. For lists, you need manual cache updates:

```tsx
import { useMutation } from '@apollo/client'
import { CREATE_RESUME_VARIANT, GET_RESUME_VARIANTS } from '@/graphql'

function useCreateResumeVariant() {
  const [createVariant, { loading, error }] = useMutation(CREATE_RESUME_VARIANT, {
    update(cache, { data: { createResumeVariant } }) {
      // Read existing list from cache
      const existing: any = cache.readQuery({ query: GET_RESUME_VARIANTS })

      // Write updated list back to cache
      cache.writeQuery({
        query: GET_RESUME_VARIANTS,
        data: {
          resumeVariants: [...(existing?.resumeVariants || []), createResumeVariant],
        },
      })
    },
  })

  return { createVariant, loading, error }
}
```

### Optimistic Updates

For better UX, update the UI immediately before the server responds:

```tsx
function useDeleteResumeVariant() {
  const [deleteVariant] = useMutation(DELETE_RESUME_VARIANT, {
    optimisticResponse: (vars) => ({
      deleteResumeVariant: vars.id,
    }),
    update(cache, { data }) {
      if (!data?.deleteResumeVariant) return

      const existing: any = cache.readQuery({ query: GET_RESUME_VARIANTS })

      cache.writeQuery({
        query: GET_RESUME_VARIANTS,
        data: {
          resumeVariants: existing.resumeVariants.filter(
            (v: any) => v.id !== data.deleteResumeVariant,
          ),
        },
      })
    },
  })

  return { deleteVariant }
}
```

## Hybrid GraphQL + REST Pattern

Job-Forge uses:
- **GraphQL** for complex nested data (resume variants, applications)
- **REST (Axios)** for simple resources (personal info, file uploads)

```tsx
// GraphQL for resume data
function ResumeEditor({ variantId }: { variantId: string }) {
  const { data, loading } = useQuery(GET_RESUME_VARIANT, {
    variables: { id: variantId },
  })

  // ...
}

// REST for personal info
function PersonalInfoForm() {
  const { data, loading, updatePersonalInfo } = usePersonalInfo()

  const handleSubmit = async (values: Partial<PersonalInfo>) => {
    await updatePersonalInfo(values)
  }

  // ...
}
```

## Form Handling with Zod

```tsx
import { z } from 'zod'
import { useState } from 'react'

const createResumeSchema = z.object({
  name: z.string().min(1, 'Name is required').max(100),
  description: z.string().max(500).optional(),
})

type CreateResumeForm = z.infer<typeof createResumeSchema>

function CreateResumeModal() {
  const [formData, setFormData] = useState<CreateResumeForm>({ name: '', description: '' })
  const [errors, setErrors] = useState<Record<string, string>>({})
  const { createVariant, loading } = useCreateResumeVariant()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    // Validate with Zod
    const result = createResumeSchema.safeParse(formData)
    if (!result.success) {
      const fieldErrors = result.error.flatten().fieldErrors
      setErrors(
        Object.entries(fieldErrors).reduce(
          (acc, [key, value]) => ({ ...acc, [key]: value?.[0] || '' }),
          {},
        ),
      )
      return
    }

    try {
      await createVariant({ variables: { input: result.data } })
      // Close modal, show success toast, etc.
    } catch (err) {
      console.error(err)
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        value={formData.name}
        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
      />
      {errors.name && <p className="text-red-500">{errors.name}</p>}

      <button type="submit" disabled={loading}>
        {loading ? 'Creating...' : 'Create Resume'}
      </button>
    </form>
  )
}
```

## Testing Patterns

```tsx
import { render, screen, waitFor } from '@testing-library/react'
import { MockedProvider } from '@apollo/client/testing'
import { ResumeList } from './ResumeList'
import { GET_RESUME_VARIANTS } from '@/graphql'

const mocks = [
  {
    request: {
      query: GET_RESUME_VARIANTS,
    },
    result: {
      data: {
        resumeVariants: [
          {
            id: '1',
            name: 'FinTech Resume',
            __typename: 'ResumeVariant',
          },
        ],
      },
    },
  },
]

test('displays resume variants', async () => {
  render(
    <MockedProvider mocks={mocks} addTypename={false}>
      <ResumeList />
    </MockedProvider>,
  )

  await waitFor(() => {
    expect(screen.getByText('FinTech Resume')).toBeInTheDocument()
  })
})
```

## Anti-Patterns to Avoid

❌ **Don't store GraphQL data in useState**

```tsx
// BAD
const [variants, setVariants] = useState([])
const { data } = useQuery(GET_RESUME_VARIANTS)
useEffect(() => {
  if (data) setVariants(data.resumeVariants)
}, [data])
```

✅ **Use Apollo Client cache directly**

```tsx
// GOOD
const { data } = useQuery(GET_RESUME_VARIANTS)
return <div>{data?.resumeVariants.map(...)}</div>
```

❌ **Don't manually refetch on mutations**

```tsx
// BAD
const { refetch } = useQuery(GET_RESUME_VARIANTS)
const [deleteVariant] = useMutation(DELETE_RESUME_VARIANT, {
  onCompleted: () => refetch(),
})
```

✅ **Update cache in mutation**

```tsx
// GOOD
const [deleteVariant] = useMutation(DELETE_RESUME_VARIANT, {
  update(cache, { data }) {
    // Update cache manually
  },
})
```

## Resources

- [Apollo Client Documentation](https://www.apollographql.com/docs/react/)
- [React 19 Documentation](https://react.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Zod Validation](https://zod.dev/)
