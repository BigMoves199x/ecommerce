
// Core Entity Types

export type UUID = string;

export interface BaseEntity {
  id: UUID;
  createdAt: Date;
  updatedAt: Date;
  deletedAt?: Date | null;
}

// Product & Category


export interface Category extends BaseEntity {
  name: string;
  slug: string;
  description?: string;
  parentId?: UUID | null;
  imageUrl?: string | null;
}

export interface Product extends BaseEntity {
  title: string;
  description?: string;
  price: number;
  discountPrice?: number | null;
  stock: number;
  sku: string;
  brand?: string | null;
  categoryId: UUID;
  category?: Category;
  imageUrls: string[];
  sizes?: string[];   // e.g., ["S", "M", "L", "XL"]
  colors?: string[];  // e.g., ["Navy Blue", "Charcoal", "White"]
  material?: string;  // e.g., "Wool Blend", "Cotton"
  gender?: "Men" | "Women" | "Unisex";
  tags?: string[];
  isFeatured?: boolean;
  active?: boolean;
}

// Cart & Orders


export interface CartItem {
  productId: UUID;
  quantity: number;
  size?: string;
  color?: string;
}

export interface Cart {
  id: UUID;
  userId: UUID;
  items: CartItem[];
  totalQuantity: number;
  totalPrice: number;
}

export type PaymentStatus = "PENDING" | "PAID" | "FAILED" | "REFUNDED";

export type OrderStatus =
  | "PENDING"
  | "PROCESSING"
  | "SHIPPED"
  | "DELIVERED"
  | "CANCELLED";

export interface Order extends BaseEntity {
  userId: UUID;
  items: CartItem[];
  totalAmount: number;
  paymentStatus: PaymentStatus;
  orderStatus: OrderStatus;
  shippingAddressId: UUID;
  trackingNumber?: string | null;
  notes?: string;
}


// User & Profile


export interface User extends BaseEntity {
  firstName: string;
  lastName: string;
  email: string;
  passwordHash: string;
  phone?: string;
  role?: "CUSTOMER" | "ADMIN";
  avatarUrl?: string | null;
}

export interface Address extends BaseEntity {
  userId: UUID;
  fullName: string;
  phone: string;
  street: string;
  city: string;
  state: string;
  country: string;
  postalCode: string;
  isDefault?: boolean;
}

// Reviews & Ratings


export interface Review extends BaseEntity {
  userId: UUID;
  productId: UUID;
  rating: number; // 1–5
  comment?: string;
  verifiedPurchase?: boolean;
}

// ---------------------------------------
// Marketing / Content
// ---------------------------------------

export interface Banner {
  id: UUID;
  title: string;
  subtitle?: string;
  imageUrl: string;
  linkUrl?: string;
  active?: boolean;
}

export interface PromoCode {
  id: UUID;
  code: string;
  discountPercentage: number;
  validFrom: Date;
  validUntil: Date;
  isActive: boolean;
}

// ---------------------------------------
// Modern Branding Metadata
// ---------------------------------------

export interface StoreMetadata {
  name: string;          // e.g. "ModernTailor" or "The Corporate Edit"
  slogan: string;        // e.g. "Sharp Looks. Smarter Style."
  description: string;   // e.g. "A contemporary men’s and women’s corporate wear brand built for the modern professional."
  logoUrl?: string;
  supportEmail?: string;
  supportPhone?: string;
  currency?: string;    
}
